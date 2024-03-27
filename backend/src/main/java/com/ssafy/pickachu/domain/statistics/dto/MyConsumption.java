package com.ssafy.pickachu.domain.statistics.dto;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class MyConsumption {
    String userName;
    int totalAmount;
    List<Category> mainConsumption = new ArrayList<>();

    int thisMonthAmount;
    int amountGap;
    List<CalendarAmount> calendar;
}
