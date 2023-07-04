package com.example.backend.board.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class BoardModifyRequest {
    private String title;
    private String content;
}
