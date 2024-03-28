package com.ssafy.pickachu.domain.cards.recommend.repository;

import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListPage;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListReq;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsRes;
import com.ssafy.pickachu.domain.cards.recommend.entity.CardInfo;

import com.ssafy.pickachu.domain.cards.recommend.entity.Cards;
import com.ssafy.pickachu.domain.cards.recommend.mapper.CardsMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.data.mongodb.core.aggregation.AggregationOperation;
import org.springframework.data.mongodb.core.aggregation.AggregationResults;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@Component
public class CardsAggregationImpl implements CardsAggregation {


    private final MongoTemplate mongoTemplate;
    private final CardsMapper cardsMapper;

    @Override
    public CardsListPage GetCardsCategoryList(CardsListReq cardsListReq, List<String> cardsRanking) {
        Query query = new Query(Criteria.where("categories").in(cardsListReq.getCategory()));
        List<CardInfo> findCategoryCards = mongoTemplate.find(query, CardInfo.class);
        log.info("TEST LOG : " + cardsListReq.getPageSize()  + " " + cardsListReq.getPageNumber());
        findCategoryCards.sort(Comparator.comparingInt(cardId -> {
            int index = cardsRanking.indexOf(cardId.getCardId());
            return index != -1 ? index : Integer.MAX_VALUE;
        }));

        List<CardInfo> returnPageCards = new ArrayList<>();
        int cardsSize = (cardsListReq.getPageNumber() - 1) * cardsListReq.getPageSize();
        for (int i = cardsSize; i < cardsSize + cardsListReq.getPageSize() + 1; i++) {
            try {
                returnPageCards.add(findCategoryCards.get(i));
            } catch (IndexOutOfBoundsException ignored) {
            }
        }
        Boolean nextPage = false;
        if (returnPageCards.size() == 6) {
            returnPageCards.remove(5);
            nextPage = true;
        }

        AggregationOperation limit = Aggregation.limit(returnPageCards.size());
        AggregationOperation match = Aggregation.match(Criteria.where("_id").in(returnPageCards.stream()
            .map(CardInfo::getCardId)
            .collect(Collectors.toList())));
        Aggregation aggregation = Aggregation.newAggregation(match, limit);

        List<CardsRes> cardsResList = new ArrayList<>();

        AggregationResults<Cards> results = mongoTemplate.aggregate(aggregation, "cards", Cards.class);
        List<Cards> cardsList = results.getMappedResults();
        cardsList.forEach(cards -> {
            Optional<CardInfo> matchingCardInfo = findCategoryCards.stream()
                .filter(cardInfo -> cardInfo.getCardId().equals(cards.getId()))
                .findFirst();
            CardsRes tmpRes = cardsMapper.toCardsRes(cards);
            matchingCardInfo.ifPresent(cardInfo -> {
                tmpRes.setCardContent((String)((Map<String, Object>)cardInfo
                    .getContents().get(cardsListReq.getCategory()).get(1))
                    .get("benefitSummary"));
                cardsResList.add(tmpRes);
            });
        });
        return new CardsListPage(cardsResList, cardsListReq.getPageNumber(), cardsListReq.getPageSize(), !nextPage);
    }


}
