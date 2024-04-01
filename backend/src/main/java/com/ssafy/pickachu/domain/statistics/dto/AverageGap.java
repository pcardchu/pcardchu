package com.ssafy.pickachu.domain.statistics.dto;

import com.google.gson.annotations.SerializedName;
import lombok.AllArgsConstructor;
import lombok.Data;


@Data
@AllArgsConstructor
public class AverageGap {

    String ageGroup;
    String gender;
    int lastMonth;
    int percent;


}
