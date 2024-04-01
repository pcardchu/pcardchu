package com.ssafy.pickachu.domain.cards.recommend.service;


import com.ssafy.pickachu.domain.cards.personalcards.repository.PersonalCardsRepository;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardDetailRes;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListPage;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListReq;
import com.ssafy.pickachu.domain.cards.recommend.entity.CardInfo;
import com.ssafy.pickachu.domain.cards.recommend.entity.Cards;
import com.ssafy.pickachu.domain.cards.recommend.repository.CardInfoRepository;
import com.ssafy.pickachu.domain.cards.recommend.repository.CardsRepository;
import com.ssafy.pickachu.domain.cards.recommend.repository.CardsAggregation;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;



@Transactional
@RequiredArgsConstructor
@Service
public class RecommendServiceImpl implements RecommendService{

    private final CardsRepository cardsRepository;
    private final CardInfoRepository cardInfoRepository;
    private final CardsAggregation cardsAggregation;
    private final PersonalCardsRepository personalCardsRepository;

    @Transactional(readOnly=true)
    @Override
    public CardsListPage GetCategoryCardsList(CardsListReq cardsListReq){
        List<String> cardsRankingList = personalCardsRepository.getPersonalCardsRankingList();
        return cardsAggregation.GetCardsCategoryList(cardsListReq, cardsRankingList);
    }

    @Override
    public CardDetailRes GetCardDetail(String cardsId) {
        Cards cards = cardsRepository.findById(cardsId).orElseThrow(
            () -> new RuntimeException("cards not exist")
        );
        CardInfo cardInfo = cardInfoRepository.findCardInfoByCardId(cardsId).orElseThrow(
            () -> new RuntimeException("cards not xexist")
        );

        Map<String, List<Object>> test = cardInfo.getContents();
        Set<Map.Entry<String, List<Object>>> entries = test.entrySet();
        List<ArrayList<String>> benefits = entries.stream().map(entry ->{
                Object value = entry.getValue().get(1);
                if (value instanceof Map) {
                    Map<String, String> mapValue = (Map<String, String>) value;
                    ArrayList<String> result = new ArrayList<>(){{
                        add(entry.getKey());
                        add(mapValue.get("benefitSummary"));
                    }};
                    return result;
                }
                return null;
            })
            .filter(Objects::nonNull)
            .toList();

        return CardDetailRes.builder()
            .cardId(cardsId)
            .cardName(cards.getCardName())
            .tag(cardInfo.getAnnualFeeInfo())
            .cardImg(cards.getImageUrl())
            .company(cards.getOrganization_id())
            .registrationUrl(cards.getRegistrationUrl())
            .benefits(benefits)
            .build();
    }

}
