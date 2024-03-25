package com.ssafy.pickachu.domain.cards.mycards.repository;

import com.ssafy.pickachu.domain.cards.mycards.entity.PersonalCards;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PersonalCardsRepository extends JpaRepository<PersonalCards, Long>, PersonalCardsRepositoryQuerydsl {

    Optional<PersonalCards> findPersonalCardsByUserIdAndCardsId(int userId, String cardsId);

}
