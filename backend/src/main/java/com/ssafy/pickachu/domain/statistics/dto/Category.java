package com.ssafy.pickachu.domain.statistics.dto;

import lombok.Data;

@Data
public class Category {
    String categoryName;
    int amount;

    public Category(String categoryName, int amount){
        this.categoryName = categoryName; this.amount = amount;
    }
}
