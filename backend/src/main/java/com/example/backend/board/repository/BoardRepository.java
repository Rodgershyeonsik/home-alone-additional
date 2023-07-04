package com.example.backend.board.repository;

import com.example.backend.board.entity.Board;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface BoardRepository extends JpaRepository<Board, Long> {

    @Query(value = "select b from Board b join fetch b.boardCategory tb where tb.categoryId = :categoryId",
    countQuery = "select count(b) from Board b where b.boardCategory.categoryId = :categoryId")
    Page<Board> findAllByCategoryIdUsingQuery(@Param("categoryId")Long categoryId, Pageable pageable);

    @Query("select b from Board b join fetch b.member tb where tb.Id = :memberId")
    List<Board> findAllBoardsByMemberId(@Param("memberId")Long memberId, Sort sort);

    Page<Board> findAll(Pageable pageable);

}
