package com.example.backend.board.service;

import com.example.backend.board.entity.Board;
import com.example.backend.board.entity.BoardCategory;
import com.example.backend.board.entity.BoardImage;
import com.example.backend.board.repository.BoardImageRepository;
import com.example.backend.member.entity.Member;
import com.example.backend.board.repository.BoardCategoryRepository;
import com.example.backend.board.repository.BoardRepository;
import com.example.backend.member.repository.MemberRepository;
import com.example.backend.board.dto.BoardModifyRequest;
import com.example.backend.board.dto.BoardRegisterRequest;
import com.example.backend.board.dto.BoardResponse;
import com.example.backend.board.dto.PagedBoardResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@Transactional
public class BoardServiceImpl implements BoardService {
    private final String uploadDir = "D:\\additional\\home-alone-additional\\backend\\src\\main\\resources\\images";

    @Autowired
    MemberRepository memberRepository;
    @Autowired
    BoardCategoryRepository categoryRepository;
    @Autowired
    BoardRepository boardRepository;
    @Autowired
    BoardImageRepository boardImageRepository;
    @Override
    public Boolean register(BoardRegisterRequest boardRegisterRequest) {
        BoardCategory boardCategory;
        Member member;
        Optional<BoardCategory> maybeCategory = categoryRepository.findByCategoryName(boardRegisterRequest.getBoardCategoryName());

        if(maybeCategory.isEmpty()) {
            boardCategory = new BoardCategory(boardRegisterRequest.getBoardCategoryName());
        } else {
            boardCategory = maybeCategory.get();
        }
        Optional<Member> maybeMember = memberRepository.findByNickname(boardRegisterRequest.getWriter());

        if(maybeMember.isPresent()) {
            member = maybeMember.get();
        } else {
            throw new RuntimeException("존재하지 않는 사용자 닉네임");
        }

        Board board = new Board();

        board.setTitle(boardRegisterRequest.getTitle());
        board.setContent(boardRegisterRequest.getContent());
        board.setWriter(boardRegisterRequest.getWriter());

        boardCategory.setBoard(board);
        categoryRepository.save(boardCategory);

        member.setBoard(board);
        memberRepository.save(member);

        boardRepository.save(board);

        return true;
    }

    @Override
    public PagedBoardResponse getCategoryBoardListWithPage(String categoryName, int pageIndex) {
        BoardCategory boardCategory;

        Optional<BoardCategory> maybeCategory = categoryRepository.findByCategoryName(categoryName);
        if(maybeCategory.isPresent()) {
            boardCategory = maybeCategory.get();

            final int PAGE_SIZE = 10;
            Sort newest = Sort.by(Sort.Direction.DESC, "boardNo");
            PageRequest pageRequest = PageRequest.of(pageIndex, PAGE_SIZE, newest);
            Page<Board> boardPage =
                    boardRepository.findAllByCategoryIdUsingQuery(boardCategory.getCategoryId(), pageRequest);
            List<Board> entities = boardPage.getContent();

            Integer totalPages = boardPage.getTotalPages();
            List<BoardResponse> boards = entities.stream()
                    .map(BoardResponse::new).
                    collect(Collectors.toList());

            return new PagedBoardResponse(totalPages, boards);
        } else {
            throw new RuntimeException("존재하지 않는 게시판");
        }
    }

    @Override
    public BoardResponse read(Long boardNo) {
        Optional<Board> maybeBoard = boardRepository.findById(boardNo);

        if (maybeBoard.isEmpty()) {
            log.info("Can't read board!!!");

            return null;
        }
        Board board = maybeBoard.get();
        return new BoardResponse(board);
    }

    @Override
    public BoardResponse modify(Long boardNo, BoardModifyRequest boardModifyRequest) {
        Board modifyBoard;

        Optional<Board> maybeBoard = boardRepository.findById(boardNo);
        if(maybeBoard.isPresent()) {
            modifyBoard = maybeBoard.get();
            modifyBoard.setTitle(boardModifyRequest.getTitle());
            modifyBoard.setContent(boardModifyRequest.getContent());
            boardRepository.save(modifyBoard);

            return new BoardResponse(modifyBoard);
        } else {
            throw new RuntimeException("존재하지 않는 게시물!");
        }
    }

    @Override
    public void remove(Long boardNo) {
        boardRepository.deleteById(boardNo);
    }

    @Override
    public PagedBoardResponse getAllBoardListWithPage(int pageIndex) {
        final int PAGE_SIZE = 10;
        Sort newest = Sort.by(Sort.Direction.DESC, "boardNo");
        PageRequest pageRequest = PageRequest.of(pageIndex, PAGE_SIZE, newest);

        Page<Board> boardPage = boardRepository.findAll(pageRequest);
        log.info(boardPage.toString());

        List<Board> entities = boardPage.getContent();

        Integer totalPages = boardPage.getTotalPages();
        List<BoardResponse> boards = entities.stream()
                .map(BoardResponse::new).
                collect(Collectors.toList());

        return new PagedBoardResponse(totalPages, boards);
    }
    @Override
    public Boolean registerWithImages(BoardRegisterRequest request, List<MultipartFile> files) {
        BoardCategory category;
        Member member;

        Optional<BoardCategory> maybeCategory =
                categoryRepository.findByCategoryName(request.getBoardCategoryName());

        if(maybeCategory.isEmpty()) {
            category = new BoardCategory(request.getBoardCategoryName());
        } else {
            category = maybeCategory.get();
        }

        Optional<Member> maybeMember = memberRepository.findByNickname(request.getWriter());

        if(maybeMember.isPresent()) {
            member = maybeMember.get();
        } else {
            throw new RuntimeException("존재하지 않는 사용자 닉네임");
        }

        Board newBoard = request.toBoard();
        category.setBoard(newBoard);
        member.setBoard(newBoard);


        try{
            for(MultipartFile file : files) {
                String fileName = UUID.randomUUID() + file.getOriginalFilename();
                String filePath = uploadDir + "/" + fileName;
                file.transferTo(new File(filePath));
                log.info(file.getName() + " 파일 저장 성공!");

                BoardImage image = BoardImage.builder().
                                    fileName(fileName).
                                    fileOriginName(file.getOriginalFilename()).
                                    filePath(filePath).build();
                newBoard.setImage(image);
                boardImageRepository.save(image);
            }
        } catch (IOException e) {
            log.info(e.getMessage());
            return false;
        }
        categoryRepository.save(category);
        memberRepository.save(member);
        boardRepository.save(newBoard);
        return true;
    }
}
