package com.example.backend.service.board;

import com.example.backend.service.board.request.BoardModifyRequest;
import com.example.backend.service.board.request.BoardRegisterRequest;
import com.example.backend.service.board.response.BoardResponse;

import java.util.List;

public interface BoardService {

    Boolean register(BoardRegisterRequest boardRegisterRequest);
    List<BoardResponse> everyBoardList();
    List<BoardResponse> specificBoardList(String categoryName);
    BoardResponse read(Long boardNo);
    BoardResponse modify(Long boardNo, BoardModifyRequest boardModifyRequest);
    void remove(Long boardNo);

    List<BoardResponse> getAllBoardListWithPage(int pageNum);

}
