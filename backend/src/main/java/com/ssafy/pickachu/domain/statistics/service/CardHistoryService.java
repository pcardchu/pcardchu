package com.ssafy.pickachu.domain.statistics.service;

import com.ssafy.pickachu.domain.cards.recommend.entity.CardInfo;
import com.ssafy.pickachu.domain.statistics.entity.CardHistoryEntity;
import com.ssafy.pickachu.domain.statistics.response.CardHistoryRes;
import com.ssafy.pickachu.domain.user.entity.User;
import org.springframework.http.ResponseEntity;

import java.util.List;

public interface CardHistoryService {

    ResponseEntity<CardHistoryRes> saveCardHistoriesByAirflow(String apiKey);

    void saveCardHistories(String payListResult, User user, long id);

    String CalculateBenefit(CardInfo cards, List<CardHistoryEntity> sch);

}
