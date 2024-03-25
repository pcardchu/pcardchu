package com.ssafy.pickachu.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.cassandra.core.mapping.PrimaryKey;
import org.springframework.data.cassandra.core.mapping.Table;

@Data
@NoArgsConstructor
@Table("peaktime")
public class PeakTimeAgeEntity {

    @PrimaryKey
    private int time;

    private String age;
}
