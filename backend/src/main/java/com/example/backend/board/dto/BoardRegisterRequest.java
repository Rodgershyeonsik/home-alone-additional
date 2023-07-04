package com.example.backend.board.dto;

import com.example.backend.board.entity.Board;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class BoardRegisterRequest {
    private String title;
    private String writer;
    private String content;
    private String boardCategoryName;

    public Board toBoard() { return new Board(title, writer, content); }
}
