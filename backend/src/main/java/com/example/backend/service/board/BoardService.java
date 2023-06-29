package com.example.backend.service.board;

import com.example.backend.service.board.request.BoardModifyRequest;
import com.example.backend.service.board.request.BoardRegisterRequest;
import com.example.backend.service.board.response.BoardResponse;
import com.example.backend.service.board.response.PagedBoardResponse;

import java.util.List;

public interface BoardService {

    Boolean register(BoardRegisterRequest boardRegisterRequest);
    PagedBoardResponse getCategoryBoardListWithPage(String categoryName, int pageIndex);
    BoardResponse read(Long boardNo);
    BoardResponse modify(Long boardNo, BoardModifyRequest boardModifyRequest);
    void remove(Long boardNo);

    PagedBoardResponse getAllBoardListWithPage(int pageIndex);

}
