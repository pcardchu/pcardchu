package com.ssafy.pickachu.domain.statistics.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
public class CardRankRes {
    String age;
    String gender;
    List<String> cards;
}
