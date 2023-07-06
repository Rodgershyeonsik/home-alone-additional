package com.example.backend.board.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor
public class BoardImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private String fileName;

    @Column
    private String fileOriginName;

    @Column
    private String filePath;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "board_no")
    private Board board;

    @Builder
    public BoardImage(String fileName, String fileOriginName, String filePath, Board board){
        this.fileName = fileName;
        this.fileOriginName = fileOriginName;
        this.filePath = filePath;
        this.board.getBoardImages().add(this);
        this.board = board;
    }
}
