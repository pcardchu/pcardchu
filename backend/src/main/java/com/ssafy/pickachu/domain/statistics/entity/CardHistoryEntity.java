package com.ssafy.pickachu.domain.statistics.entity;

import com.google.gson.annotations.SerializedName;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.cassandra.core.mapping.PrimaryKey;
import org.springframework.data.cassandra.core.mapping.Table;

import java.util.UUID;

@Data
@NoArgsConstructor
@Table("cardhistory")
public class CardHistoryEntity {

    @PrimaryKey
    private UUID id;
    private int userid;
    private String age;
    private String gender;
    @SerializedName("resUsedDate")
    private String date;
    @SerializedName("resUsedTime")
    private int time;
    @SerializedName("resUsedAmount")
    private int amount;
    @SerializedName("resMemberStoreType")
    private String category;
    private int cardId;
}
