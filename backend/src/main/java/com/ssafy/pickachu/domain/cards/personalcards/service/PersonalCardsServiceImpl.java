package com.ssafy.pickachu.domain.cards.personalcards.service;

import com.ssafy.pickachu.domain.cards.personalcards.dto.SimplePersonalCardsRes;
import com.ssafy.pickachu.domain.cards.personalcards.entity.PersonalCards;
import com.ssafy.pickachu.domain.cards.personalcards.repository.PersonalCardsRepository;
import com.ssafy.pickachu.domain.cards.recommend.entity.Cards;
import com.ssafy.pickachu.domain.cards.recommend.repository.CardsRepository;
import com.ssafy.pickachu.domain.user.entity.TestUsers;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;


@Transactional
@RequiredArgsConstructor
@Service
public class PersonalCardsServiceImpl implements PersonalCardsService {

    private final PersonalCardsRepository personalCardsRepository;
    private final CardsRepository cardsRepository;


    @Override
    public void DeleteMyCards(String cardid) {
        //TODO  TestUser CODE 여기 jwt 토큰을 이용한 멤버 받아오기 코드가 들어와야함
        TestUsers users = TestUsers.builder().build();
        int userId = 1;

        PersonalCards personalCards = personalCardsRepository.findPersonalCardsByUserIdAndCardsId(userId, cardid)
            .orElseThrow(() -> new RuntimeException("not exist personal card"));

        if(users.getId() != personalCards.getUserId()){
            throw new RuntimeException("not match user");
        }
        personalCards.setUseYN("N");
        personalCardsRepository.save(personalCards);
    }

    @Override
    public List<SimplePersonalCardsRes> GetPersonalCardsList() {
        //TODO  TestUser CODE 여기 jwt 토큰을 이용한 멤버 받아오기 코드가 들어와야함
        TestUsers users = TestUsers.builder().build();
        List<SimplePersonalCardsRes> simplePersonalCardsRes = personalCardsRepository.findAllByUserIdAndUseYN(users.getId(), "Y");

        simplePersonalCardsRes.forEach(simpleCards -> {
            Optional<Cards> cards = cardsRepository.findById(simpleCards.getCardsId());
            cards.ifPresent(card -> {
                simpleCards.setCardImage(card.getImageUrl());
            });
        });
        return simplePersonalCardsRes;
    }
}
