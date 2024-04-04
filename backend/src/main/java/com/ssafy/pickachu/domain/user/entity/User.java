package com.ssafy.pickachu.domain.user.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.springframework.data.annotation.LastModifiedDate;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    @Column(nullable = false, columnDefinition = "VARCHAR(255) DEFAULT 'email'")
    private String email;
    @Column(nullable = false, columnDefinition = "VARCHAR(255) DEFAULT 'nickname'")
    private String nickname;

    private Date birth;
    private String gender;
    private String deviceId;
    @Column(columnDefinition = "VARCHAR(1000)")
    private String connectedId;
    @Column(nullable = false, columnDefinition = "int(11) DEFAULT 0")
    private int flagBiometrics;
    private String shortPw;
    @Column(nullable = false, columnDefinition = "int(1) DEFAULT 0")
    private int pwWrongCount;

    @Column(nullable = false, columnDefinition = "VARCHAR(255) DEFAULT 'provider'")
    private String provider;
    @Column(nullable = false, columnDefinition = "VARCHAR(255) DEFAULT 'identifier'")
    private String identifier;
    @Column(nullable = false, columnDefinition = "VARCHAR(255) DEFAULT 'role'")
    private String role;
    private String firstRefreshToken;
    private String secondRefreshToken;

    @CreationTimestamp
    private Timestamp createTime;

    @LastModifiedDate
    private LocalDateTime updateTime;
    private String useYN;

}
