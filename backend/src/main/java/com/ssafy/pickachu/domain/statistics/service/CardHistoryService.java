package com.ssafy.pickachu.domain.statistics.service;

import com.ssafy.pickachu.domain.statistics.response.CardHistoryRes;
import com.ssafy.pickachu.domain.user.entity.User;
import org.springframework.http.ResponseEntity;

public interface CardHistoryService {

    ResponseEntity<CardHistoryRes> saveCardHistoriesByAirflow(String apiKey);

    void saveCardHistories(String payListResult, User user, long id);


}
