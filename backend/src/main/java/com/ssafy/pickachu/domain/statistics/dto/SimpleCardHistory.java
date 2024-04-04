package com.ssafy.pickachu.domain.statistics.dto;

import com.google.gson.annotations.SerializedName;
import lombok.*;

@Getter
@Setter
@Builder
@ToString
@AllArgsConstructor
public class SimpleCardHistory {

    @SerializedName("resMemberStoreType")
    private String category;
    @SerializedName("resUsedAmount")
    private int amount;
    @SerializedName("resUsedDate")
    private String date;
    @SerializedName("resUsedTime")
    int time;
}
