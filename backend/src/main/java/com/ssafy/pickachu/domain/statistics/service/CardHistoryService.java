package com.ssafy.pickachu.domain.statistics.service;

import com.ssafy.pickachu.domain.statistics.response.CardHistoryRes;
import org.springframework.http.ResponseEntity;

public interface CardHistoryService {

    ResponseEntity<CardHistoryRes> saveCardHistories(String apiKey);

}
