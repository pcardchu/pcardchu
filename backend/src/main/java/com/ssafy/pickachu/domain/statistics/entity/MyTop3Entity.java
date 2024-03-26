package com.ssafy.pickachu.domain.statistics.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.cassandra.core.mapping.PrimaryKey;
import org.springframework.data.cassandra.core.mapping.Table;

@Data
@NoArgsConstructor
@Table("mytop3")
public class MyTop3Entity implements Comparable<MyTop3Entity> {

    @PrimaryKey
    private int id;

    private int userid;

    private String date;

    private String category;

    @Override
    public int compareTo(MyTop3Entity o) {
        return this.id-o.id;
    }
}
