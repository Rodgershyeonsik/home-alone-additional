package com.example.backend.service.board.response;

import lombok.Getter;

import java.util.List;
@Getter
public class PagedBoardResponse {
    private final Integer totalPages;
    private final List<BoardResponse> boards;

    public PagedBoardResponse(Integer totalPages, List<BoardResponse> boards) {
        this.totalPages = totalPages;
        this.boards = boards;
    }
}
