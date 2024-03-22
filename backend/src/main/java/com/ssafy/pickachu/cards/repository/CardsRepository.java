package com.ssafy.pickachu.cards.repository;

import com.ssafy.pickachu.cards.entity.Cards;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface CardsRepository extends MongoRepository<Cards, String> {

//    Optional<Cards> findCardsByCardNum(String cardNum);
}
