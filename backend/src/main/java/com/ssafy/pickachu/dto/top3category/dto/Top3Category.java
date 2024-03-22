package com.ssafy.pickachu.dto.top3category.dto;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class Top3Category {
    String age;
    String gender;
    List<String> categoryList = new ArrayList<>();

    public Top3Category(String age, String gender) {
        this.age = age; this.gender = gender;
    }
}
