package com.ssafy.pickachu.domain.cards.personalcards.controller;

import com.ssafy.pickachu.domain.auth.PrincipalDetails;
import com.ssafy.pickachu.domain.cards.personalcards.dto.RegisterCardsReq;
import com.ssafy.pickachu.domain.cards.personalcards.service.PersonalCardsService;
import com.ssafy.pickachu.domain.statistics.entity.CardHistoryEntity;
import com.ssafy.pickachu.domain.statistics.repository.CardHistoryEntityRepository;
import com.ssafy.pickachu.global.crawling.service.CrawlingService;
import com.ssafy.pickachu.global.result.SuccessCode;
import com.ssafy.pickachu.global.result.SuccessResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/cards")
@RequiredArgsConstructor
@Tag(name="CardsController", description = "내 카드 관련 api")
public class PersonalCardsController {

    private final PersonalCardsService personalCardsService;
    private final CardHistoryEntityRepository repository;

    @Operation(summary = "내 카드 제거하기")
    @DeleteMapping("/my-cards/{cardId}")
    public ResponseEntity<SuccessResponse> DeleteMyCards(@AuthenticationPrincipal PrincipalDetails principalDetails, @PathVariable String cardId){
        personalCardsService.DeleteMyCards(principalDetails, cardId);
        return ResponseEntity.ok(SuccessResponse.of(SuccessCode.DELETE_PERSONAL_CARDS_SUCCESS));
    }


    @Operation(summary = "내 카드 리스트 조회")
    @GetMapping("/my-cards")
    public ResponseEntity<SuccessResponse> GetMyCardsList(@AuthenticationPrincipal PrincipalDetails principalDetails){
        return ResponseEntity.ok(SuccessResponse
            .of(SuccessCode.PERSONAL_CARDS_LIST_SUCCESS,
                personalCardsService.GetPersonalCardsList(principalDetails)));
    }

    @Operation(summary = "내 카드 등록")
    @PostMapping("/my-cards")
    public ResponseEntity<SuccessResponse> RegistPersonalCards(@AuthenticationPrincipal PrincipalDetails principalDetails, @RequestBody RegisterCardsReq registerCardsReq){
        personalCardsService.RegisterMyCards(principalDetails, registerCardsReq);
        return ResponseEntity.ok(SuccessResponse.of(SuccessCode.CARD_REGIST_SUCCEST, true));
    }

    @GetMapping("/test")
    public void Test123123(){
        List<CardHistoryEntity> ttt = repository.findMyCardHistoryById(1);
        Map<String, Integer> tt = new HashMap<>();
        for (CardHistoryEntity cardHistoryEntity : ttt) {
            int t = tt.getOrDefault(cardHistoryEntity.getCategory(), 0);
            tt.put(cardHistoryEntity.getCategory(), t + 1);
        }
        System.out.println(tt.toString());

        for (String s : tt.keySet()) {
            System.out.println("put(\""+s+"\", \"\"");

        }
    }

}
