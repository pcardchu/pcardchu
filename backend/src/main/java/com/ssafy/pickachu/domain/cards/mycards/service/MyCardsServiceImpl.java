package com.ssafy.pickachu.domain.cards.mycards.service;

import com.ssafy.pickachu.domain.cards.mycards.entity.PersonalCards;
import com.ssafy.pickachu.domain.cards.mycards.repository.PersonalCardsRepository;
import com.ssafy.pickachu.domain.user.entity.Users;
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
        Users users = Users.builder().build();
        int userId = 1;

        PersonalCards personalCards = personalCardsRepository.findPersonalCardsByUserIdAndCardsId(userId, cardid)
            .orElseThrow(() -> new RuntimeException("not exist personal card"));

        if(users.getId() != personalCards.getUserId()){
            throw new RuntimeException("not match user");
        }
        personalCards.setUseYN("N");
        personalCardsRepository.save(personalCards);
    }
}
