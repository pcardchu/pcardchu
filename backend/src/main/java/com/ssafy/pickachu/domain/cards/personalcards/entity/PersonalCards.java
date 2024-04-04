package com.ssafy.pickachu.domain.cards.personalcards.entity;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Setter
@Builder
@EntityListeners(AuditingEntityListener.class)
@Entity
public class PersonalCards {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    long id;
    String name;            // 카드 이름
    String cardCompany;     // 카드 회사
    long userId;             // 유저 ID
    String cardsId;         // Cards Entity ID
    String cardNo;          // 개인 카드 번호
    String cardCompanyId;   // 카드회사 아이디
    String cardCompanyPw;   // 카드회사 비밀번호
    @Builder.Default
    private String useYN = "Y";   // 카드 삭제 여부
    @CreatedDate
    private LocalDateTime createTime;
    @LastModifiedDate
    private LocalDateTime updateTime;

}
