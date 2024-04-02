package com.ssafy.pickachu.domain.cards.personalcards.service;

import com.ssafy.pickachu.domain.auth.PrincipalDetails;
import com.ssafy.pickachu.domain.cards.personalcards.dto.RegisterCardsReq;
import com.ssafy.pickachu.domain.cards.personalcards.dto.SimplePersonalCardsRes;

import java.util.List;

public interface PersonalCardsService {
    public void DeleteMyCards(PrincipalDetails principalDetails, String cardid);

    public List<SimplePersonalCardsRes> GetPersonalCardsList(PrincipalDetails principalDetails);

    public void RegisterMyCards(PrincipalDetails principalDetails, RegisterCardsReq registerCardsReq);

}
