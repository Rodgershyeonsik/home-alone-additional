package com.example.backend.board.dto;

import com.example.backend.board.entity.Board;
import lombok.*;

@Getter
@ToString
@NoArgsConstructor
public class BoardRegisterRequest {
    private String title;
    private String writer;
    private String content;
    private String boardCategoryName;

    public Board toBoard() {
        return Board.builder().
                title(this.title).
                writer(this.writer).
                content(this.content).build(); }
    @Builder
    public BoardRegisterRequest(String title, String writer, String content, String boardCategoryName) {
        this.title = title;
        this.writer = writer;
        this.content = content;
        this.boardCategoryName = boardCategoryName;
    }
}
