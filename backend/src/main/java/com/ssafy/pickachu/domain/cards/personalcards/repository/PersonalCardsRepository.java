package com.ssafy.pickachu.domain.cards.personalcards.repository;

import com.ssafy.pickachu.domain.cards.personalcards.dto.SimplePersonalCardsRes;
import com.ssafy.pickachu.domain.cards.personalcards.entity.PersonalCards;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface PersonalCardsRepository extends JpaRepository<PersonalCards, Long>, PersonalCardsRepositoryQuerydsl {

    Optional<PersonalCards> findPersonalCardsByUserIdAndCardsId(int userId, String cardsId);

    List<PersonalCards> findAllByUserIdAndUseYN(long userId, String userYN);

    @Query("SELECT p.cardCompany FROM PersonalCards p where p.userId = :userId and p.useYN = 'Y'")
    List<String> getPersonalCardsCardCompanyListByuser(long userId);
}
