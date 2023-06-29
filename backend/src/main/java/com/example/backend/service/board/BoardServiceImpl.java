package com.example.backend.service.board;

import com.example.backend.entity.board.Board;
import com.example.backend.entity.board.BoardCategory;
import com.example.backend.entity.member.Member;
import com.example.backend.repository.BoardCategoryRepository;
import com.example.backend.repository.BoardRepository;
import com.example.backend.repository.MemberRepository;
import com.example.backend.service.board.request.BoardModifyRequest;
import com.example.backend.service.board.request.BoardRegisterRequest;
import com.example.backend.service.board.response.BoardResponse;
import com.example.backend.service.board.response.PagedBoardResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
@Transactional
public class BoardServiceImpl implements BoardService{

    @Autowired
    MemberRepository memberRepository;

    @Autowired
    BoardCategoryRepository categoryRepository;

    @Autowired
    BoardRepository boardRepository;

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

}
