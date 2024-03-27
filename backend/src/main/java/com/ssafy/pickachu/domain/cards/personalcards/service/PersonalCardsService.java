package com.ssafy.pickachu.domain.cards.personalcards.service;

import com.ssafy.pickachu.domain.cards.personalcards.dto.SimplePersonalCardsRes;

import java.util.List;

public interface PersonalCardsService {
    public void DeleteMyCards(String cardid);

    public List<SimplePersonalCardsRes> GetPersonalCardsList();
}
