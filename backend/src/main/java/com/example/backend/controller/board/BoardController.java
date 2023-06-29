package com.example.backend.controller.board;

import com.example.backend.service.board.BoardService;
import com.example.backend.service.board.request.BoardModifyRequest;
import com.example.backend.service.board.request.BoardRegisterRequest;
import com.example.backend.service.board.response.BoardResponse;
import com.example.backend.service.board.response.PagedBoardResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

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
}
