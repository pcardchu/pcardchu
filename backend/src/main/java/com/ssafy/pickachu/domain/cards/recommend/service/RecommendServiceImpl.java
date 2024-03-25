package com.ssafy.pickachu.domain.cards.recommend.service;


import com.ssafy.pickachu.domain.cards.mycards.repository.PersonalCardsRepository;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListPage;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListReq;
import com.ssafy.pickachu.domain.cards.recommend.repository.CardsRepository;
import com.ssafy.pickachu.domain.cards.recommend.repository.CardsAggregation;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Transactional
@RequiredArgsConstructor
@Service
public class RecommendServiceImpl implements RecommendService{

    private final CardsRepository cardsRepository;
    private final CardsAggregation cardsAggregation;
    private final PersonalCardsRepository personalCardsRepository;

    @Transactional(readOnly=true)
    @Override
    public CardsListPage getCategoryCardsList(CardsListReq cardsListReq){
        List<String> cardsRankingList = personalCardsRepository.getPersonalCardsRankingList();
        return cardsAggregation.GetCardsCategoryList(cardsListReq, cardsRankingList);
    }

}
