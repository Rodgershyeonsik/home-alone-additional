package com.example.backend.service.board.response;

import com.example.backend.entity.board.Board;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BoardResponse {
    private Long boardNo;
    private String title;
    private String writer;
    private String content;
    private String categoryName;
    private Date regDate;

    public BoardResponse(Board board) {
                this.boardNo = board.getBoardNo();
                this.title = board.getTitle();
                this.writer = board.getWriter();
                this.content = board.getContent();
                this.categoryName = board.getBoardCategory().getCategoryName();
                this.regDate = board.getRegDate();
    }
}
