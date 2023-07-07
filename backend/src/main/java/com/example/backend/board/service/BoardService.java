package com.example.backend.board.service;

import com.example.backend.board.dto.BoardModifyRequest;
import com.example.backend.board.dto.BoardRegisterRequest;
import com.example.backend.board.dto.BoardResponse;
import com.example.backend.board.dto.PagedBoardResponse;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface BoardService {

    Boolean register(BoardRegisterRequest boardRegisterRequest);
    PagedBoardResponse getCategoryBoardListWithPage(String categoryName, int pageIndex);
    BoardResponse read(Long boardNo);
    BoardResponse modify(Long boardNo, BoardModifyRequest boardModifyRequest);
    void remove(Long boardNo);

    PagedBoardResponse getAllBoardListWithPage(int pageIndex);

    Boolean registerWithImages(BoardRegisterRequest request, List<MultipartFile> files);

}
