package com.ssafy.pickachu.domain.cards.recommend.controller;


import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListPage;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListReq;
import com.ssafy.pickachu.domain.cards.recommend.service.RecommendService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/cards")
@RequiredArgsConstructor
@Tag(name="CardsController", description = "카드 추천 관련 api")
public class RecommendController {

    private final RecommendService recommendService;

    @Operation(summary = "카테고리로 카드 리스트 조회")
    @PostMapping("/list")
    public ResponseEntity<CardsListPage> getCardsList(@RequestBody CardsListReq cardsListReq){
        return ResponseEntity.status(HttpStatus.FOUND).body(recommendService.getCategoryCardsList(cardsListReq));
    }

}
