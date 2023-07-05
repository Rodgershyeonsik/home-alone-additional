package com.example.backend.board.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.List;

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
    private String imgUri;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "board_no")
    private Board board;

    public BoardImage(String fileName, String fileOriginName, String imgUri, Board board){
        this.fileName = fileName;
        this.fileOriginName = fileOriginName;
        this.imgUri = imgUri;
        this.board.getBoardImages().add(this);
        this.board = board;
    }
}
