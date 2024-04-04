package com.ssafy.pickachu.domain.statistics.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.cassandra.core.mapping.PrimaryKey;
import org.springframework.data.cassandra.core.mapping.Table;

@Data
@NoArgsConstructor
@Table("top3category")
public class Top3CategoryEntity implements Comparable<Top3CategoryEntity> {

    @PrimaryKey
    private long id;

    private String age;

    private String gender;

    private String category;

    @Override
    public int compareTo(Top3CategoryEntity o) {
        return (int)(this.id-o.id);
    }
}
