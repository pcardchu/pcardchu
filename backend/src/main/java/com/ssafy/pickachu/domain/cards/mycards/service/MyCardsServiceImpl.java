package com.ssafy.pickachu.domain.cards.mycards.service;

import com.ssafy.pickachu.domain.cards.mycards.entity.PersonalCards;
import com.ssafy.pickachu.domain.cards.mycards.repository.PersonalCardsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Transactional
@RequiredArgsConstructor
@Service
public class MyCardsServiceImpl implements MyCardsService{

    private final PersonalCardsRepository personalCardsRepository;

    @Override
    public void DeleteMyCards(String cardid) {
        //TODO  여기 jwt 토큰을 이용한 멤버 받아오기 코드가 들어와야함
        int userId = 1;
        PersonalCards personalCards = personalCardsRepository.findPersonalCardsByUserIdAndCardsId(userId, cardid)
            .orElseThrow(() -> new RuntimeException("not exist personal card"));
        personalCards.setUseYN("N");
        personalCardsRepository.save(personalCards);
    }
}
