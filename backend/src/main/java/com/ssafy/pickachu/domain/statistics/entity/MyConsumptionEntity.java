package com.ssafy.pickachu.domain.statistics.entity;

import com.google.gson.annotations.SerializedName;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.cassandra.core.mapping.PrimaryKey;
import org.springframework.data.cassandra.core.mapping.Table;

@Data
@NoArgsConstructor
@Table("myconsumption")
public class MyConsumptionEntity implements Comparable<MyConsumptionEntity> {

    @PrimaryKey
    private int id;

    private int userid;

    private String date;

    private String category;

    @SerializedName("totalamount")
    private int totalAmount;

    @Override
    public int compareTo(MyConsumptionEntity o) {
        return this.id-o.id;
    }
}
