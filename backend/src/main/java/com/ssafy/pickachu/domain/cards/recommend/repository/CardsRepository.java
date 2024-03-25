package com.ssafy.pickachu.domain.cards.recommend.repository;

import com.ssafy.pickachu.domain.cards.recommend.entity.Cards;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface CardsRepository extends MongoRepository<Cards, String> {


}
