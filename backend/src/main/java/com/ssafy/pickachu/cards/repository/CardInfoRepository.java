package com.ssafy.pickachu.cards.repository;


import com.ssafy.pickachu.cards.entity.CardInfo;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface CardInfoRepository extends MongoRepository<CardInfo, String> {
}
