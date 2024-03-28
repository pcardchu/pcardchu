package com.ssafy.pickachu.domain.statistics.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.cassandra.core.mapping.PrimaryKey;
import org.springframework.data.cassandra.core.mapping.Table;

@Data
@NoArgsConstructor
@Table("averageamount")
public class AverageAmountEntity{

    @PrimaryKey
    private int id;

    private String age;

    private String gender;

    private int average;

}
