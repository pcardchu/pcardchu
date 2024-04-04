package com.ssafy.pickachu.domain.statistics.dto;

import com.google.gson.annotations.SerializedName;
import lombok.Data;


@Data
public class CardHistory {

    int userId=-1;
    String gender ="";
    String age = "";
    @SerializedName("resUsedDate")
    String date;
    @SerializedName("resUsedTime")
    int time;
    @SerializedName("resUsedAmount")
    int amount;
    String category;
    int cardId=-1;

}
