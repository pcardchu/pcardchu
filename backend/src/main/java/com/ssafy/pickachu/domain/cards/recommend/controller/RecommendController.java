package com.ssafy.pickachu.domain.cards.recommend.controller;


import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListReq;
import com.ssafy.pickachu.domain.cards.recommend.service.RecommendService;
import com.ssafy.pickachu.global.result.SuccessCode;
import com.ssafy.pickachu.global.result.SuccessResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springdoc.core.annotations.ParameterObject;
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
    @GetMapping("/list")
    public ResponseEntity<Object> getCardsList(@ModelAttribute @ParameterObject CardsListReq cardsListReq){
        return ResponseEntity.ok(SuccessResponse.of(SuccessCode.GET_CATEGORY_CARDS_LIST_SUCCESS,recommendService.getCategoryCardsList(cardsListReq)));
    }

    @Operation(summary = "카드 디테일 조회")
    @GetMapping("/list/detail/{cardsId}")
    public ResponseEntity<Object> getCardDetail(@PathVariable String cardsId){
        return ResponseEntity.status(HttpStatus.FOUND).body(recommendService.getCardDetail(cardsId));
    }

}
