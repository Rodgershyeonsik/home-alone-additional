package com.example.backend.board.controller;

import com.example.backend.board.service.BoardService;
import com.example.backend.board.dto.BoardModifyRequest;
import com.example.backend.board.dto.BoardRegisterRequest;
import com.example.backend.board.dto.BoardResponse;
import com.example.backend.board.dto.PagedBoardResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/board")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class BoardController {

    @Autowired
    private BoardService service;

    @GetMapping("/all-boards-with-page/{pageIndex}")
    public PagedBoardResponse getAllBoardsWithPage(@PathVariable("pageIndex") int pageIndex) {
        return service.getAllBoardListWithPage(pageIndex);
    }

    @GetMapping("/category-boards-with-page/{categoryName}/{pageIndex}")
    public PagedBoardResponse getCategoryBoardListWithPage(
            @PathVariable("categoryName") String categoryName,
            @PathVariable("pageIndex") int pageIndex) {
        log.info("specificBoardList()");

        return service.getCategoryBoardListWithPage(categoryName, pageIndex);
    }

    @PostMapping("/register")
    public boolean boardRegister(@RequestBody BoardRegisterRequest boardRegisterRequest) {
        log.info("boardRegister()");

        return service.register(boardRegisterRequest);
    }

    @GetMapping("/{boardNo}")
    public BoardResponse boardRead(@PathVariable("boardNo") Long boardNo) {
        log.info("boardRead()");

        return service.read(boardNo);
    }

    @DeleteMapping("/{boardNo}")
    public void boardRemove(@PathVariable("boardNo") Long boardNo) {
        log.info("boardRemove()");

        service.remove(boardNo);
    }

    @PutMapping("/{boardNo}")
    public BoardResponse boardModify(@PathVariable("boardNo") Long boardNo, @RequestBody BoardModifyRequest boardModifyRequest) {
        log.info("boardModify()");

        return service.modify(boardNo, boardModifyRequest);
    }

    @PostMapping(value = "/register-with-image", consumes = { MediaType.MULTIPART_FORM_DATA_VALUE, MediaType.APPLICATION_JSON_VALUE })
    public Boolean boardRegisterWithImage(
            @RequestPart("request") BoardRegisterRequest request,
            @RequestPart("file") List<MultipartFile> files) {
                log.info("boardRegisterWithImage()");
                return service.registerWithImages(request, files);

    }
}
