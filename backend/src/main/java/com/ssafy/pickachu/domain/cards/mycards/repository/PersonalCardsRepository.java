package com.ssafy.pickachu.domain.cards.mycards.repository;

import com.ssafy.pickachu.domain.cards.mycards.entity.PersonalCards;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsRes;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.mongodb.repository.Query;

import java.util.List;

public interface PersonalCardsRepository extends JpaRepository<PersonalCards, Long>, PersonalCardsRepositoryQuerydsl {

}
