package com.ssafy.pickachu.domain.user.entity;

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
@EntityListeners(AuditingEntityListener.class)
@Builder
@Entity
public class Users {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;
    String email;
    String nickName;
    LocalDateTime birth;
    String gender;
    String provider;
    String identifier;
    String refreshToken;
    @CreatedDate
    private LocalDateTime createTime;
    String role;
    String deviceId;
    int flagBiometrics;
    String connectedId;
    int showPw;
    int pwWrongCount;
    @LastModifiedDate
    private LocalDateTime updateTime;
    private String useYN;
}
