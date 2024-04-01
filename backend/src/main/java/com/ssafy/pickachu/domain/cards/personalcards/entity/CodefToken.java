package com.ssafy.pickachu.domain.cards.personalcards.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.Id;
import lombok.*;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;


@AllArgsConstructor
@NoArgsConstructor
@EntityListeners(AuditingEntityListener.class)
@Getter
@Setter
@Builder
@Entity
public class CodefToken {

    @Id
    private int id;
    @Column(columnDefinition = "VARCHAR(1000)")
    private String token;
    @LastModifiedDate
    private LocalDateTime updateTime;
}
