package com.ssafy.pickachu.domain.cards.recommend.repository;


import com.ssafy.pickachu.domain.cards.recommend.entity.CardInfo;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface CardInfoRepository extends MongoRepository<CardInfo, String> {

    Optional<CardInfo> findCardInfoByCardId(String cardId);
}
