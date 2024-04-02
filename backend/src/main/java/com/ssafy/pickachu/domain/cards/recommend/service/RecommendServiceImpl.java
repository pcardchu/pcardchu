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
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;



@Transactional
@RequiredArgsConstructor
@Slf4j
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
            () -> new RuntimeException("cards not exist")
        );


        List<ArrayList<String>> benefits = new ArrayList<>();
        List<String> categories = cardInfo.getCategories();
        List<String> groupCategory = cardInfo.getGroupCategory();
        log.info(groupCategory.toString());
        for (int ids = 0; ids < categories.size(); ids++){
            ArrayList<String> result = new ArrayList<>();
            String category = groupCategory.get(ids);
            String benefit = ((Map<String, String>)cardInfo.getContents().get(categories.get(ids)).get(1)).get("benefitSummary");
            result.add(category);
            result.add(benefit);
            benefits.add(result);
        }


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
