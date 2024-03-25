package com.ssafy.pickachu.domain.cards.mycards.controller;

import com.ssafy.pickachu.domain.cards.mycards.service.MyCardsService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/cards")
@RequiredArgsConstructor
@Tag(name="CardsController", description = "내 카드 관련 api")
public class MyCardsController {

    private final MyCardsService myCardsService;

    @DeleteMapping("api/cards/my-cards/{cardId}")
    public ResponseEntity<Object> DeleteMyCards(@PathVariable String cardId){
        return null;
    }
}
