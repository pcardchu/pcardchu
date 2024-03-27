package com.ssafy.pickachu.domain.cards.personalcards.controller;

import com.ssafy.pickachu.domain.cards.personalcards.service.PersonalCardsService;
import com.ssafy.pickachu.global.result.SuccessCode;
import com.ssafy.pickachu.global.result.SuccessResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/cards")
@RequiredArgsConstructor
@Tag(name="CardsController", description = "내 카드 관련 api")
public class PersonalCardsController {

    private final PersonalCardsService personalCardsService;


    @Operation(summary = "내 카드 제거하기")
    @DeleteMapping("api/cards/my-cards/{cardId}")
    public ResponseEntity<Object> DeleteMyCards(@PathVariable String cardId){
        personalCardsService.DeleteMyCards(cardId);
        return ResponseEntity.status(HttpStatus.OK).body("delete success");
    }


    @Operation(summary = "내 카드 리스트 조회")
    @GetMapping("api/cards/my-cards")
    public ResponseEntity<Object> getMyCardsList(){
        return ResponseEntity.ok(SuccessResponse
            .of(SuccessCode.PERSONAL_CARDS_LIST_SUCCESS,
                personalCardsService.GetPersonalCardsList()));
    }
}
