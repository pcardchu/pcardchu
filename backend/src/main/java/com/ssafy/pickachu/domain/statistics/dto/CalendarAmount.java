package com.ssafy.pickachu.domain.statistics.dto;

import lombok.Data;

@Data
public class CalendarAmount {
    String date;
    int amount;

    public CalendarAmount(String date, int amount){
        this.date = date; this.amount = amount;
    }
}
