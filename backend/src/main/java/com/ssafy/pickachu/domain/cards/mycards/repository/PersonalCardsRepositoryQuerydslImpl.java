package com.ssafy.pickachu.domain.cards.mycards.repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import com.ssafy.pickachu.domain.cards.mycards.entity.QPersonalCards;
import lombok.RequiredArgsConstructor;

import java.util.List;

@RequiredArgsConstructor
public class PersonalCardsRepositoryQuerydslImpl implements PersonalCardsRepositoryQuerydsl{


    private final JPAQueryFactory jpaQueryFactory;

    @Override
    public List<String> getPersonalCardsRankingList() {
        QPersonalCards pc = QPersonalCards.personalCards;
        List<String> cardsRanking = jpaQueryFactory
                .select(pc.cardsId)
                .from(pc)
                .groupBy(pc.cardsId)
                .orderBy(pc.cardsId.count().desc())
                .fetch();
        return cardsRanking;
    }
}
