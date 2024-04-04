package com.ssafy.pickachu.domain.cards.recommend.repository;

import com.ssafy.pickachu.domain.cards.recommend.entity.Cards;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface CardsRepository extends MongoRepository<Cards, String> {

    Optional<Cards> findByCardName(String cardName);

    Optional<Cards> findByImageNameRegex(String cardName);

}
