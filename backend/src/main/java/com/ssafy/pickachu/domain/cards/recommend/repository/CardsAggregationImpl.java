package com.ssafy.pickachu.domain.cards.recommend.repository;

import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListPage;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsListReq;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsRes;
import com.ssafy.pickachu.domain.cards.recommend.entity.CardInfo;

import lombok.RequiredArgsConstructor;
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

    @Override
    public CardsListPage GetCardsCategoryList(CardsListReq cardsListReq, List<String> cardsRanking) {
        Query query = new Query(Criteria.where("categories").in(cardsListReq.getCategory()));
        List<CardInfo> findCategoryCards = mongoTemplate.find(query, CardInfo.class);

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

        AggregationResults<CardsRes> results = mongoTemplate.aggregate(aggregation, "cards", CardsRes.class);
        List<CardsRes> cardsResList = results.getMappedResults();
        cardsResList.forEach(cardsRes -> {
            Optional<CardInfo> matchingCardInfo = findCategoryCards.stream()
                .filter(cardInfo -> cardInfo.getCardId().equals(cardsRes.getId()))
                .findFirst();
            matchingCardInfo.ifPresent(cardInfo -> {
                cardsRes.setSimpleBenefit((String)((Map<String, Object>)cardInfo
                    .getContents().get(cardsListReq.getCategory()).get(1))
                    .get("benefitSummary"));
            });
        });
        return new CardsListPage(cardsResList, cardsListReq.getPageNumber(), cardsListReq.getPageSize(), !nextPage);
    }


}
