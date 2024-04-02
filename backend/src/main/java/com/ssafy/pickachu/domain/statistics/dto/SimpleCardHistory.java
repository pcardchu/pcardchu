package com.ssafy.pickachu.domain.statistics.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
public class SimpleCardHistory {

    String category;
    String amount;
    String time;
}
