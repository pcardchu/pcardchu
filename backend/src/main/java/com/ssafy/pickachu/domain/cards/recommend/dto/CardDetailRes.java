package com.ssafy.pickachu.domain.cards.recommend.dto;


import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Builder
public class CardDetailRes {

    String cardId;
    String cardImg;
    String cardName;
    String company;
    String registrationUrl;
    List<String> tag;
    List<ArrayList<String>> benefits;
}
