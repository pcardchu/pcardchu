package com.ssafy.pickachu.domain.auth.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Slf4j
@Component
public class JwtUtil {
    private final SecretKey secretKeyForFirstAccess;
    private final SecretKey secretKeyForFirstRefresh;
    private final SecretKey secretKeyForSecondAccess;
    private final SecretKey secretKeyForSecondRefresh;

    public JwtUtil(@Value("${key.first-jwt-access}") String secretForFirstAccess,
                   @Value("${key.first-jwt-refresh}") String secretForFirstRefresh,
                   @Value("${key.second-jwt-access}") String secretForSecondAccess,
                   @Value("${key.second-jwt-refresh}") String secretForSecondRefresh) {
        secretKeyForFirstAccess = new SecretKeySpec(secretForFirstAccess.getBytes(StandardCharsets.UTF_8), Jwts.SIG.HS256.key().build().getAlgorithm());
        secretKeyForFirstRefresh = new SecretKeySpec(secretForFirstRefresh.getBytes(StandardCharsets.UTF_8), Jwts.SIG.HS256.key().build().getAlgorithm());
        secretKeyForSecondAccess = new SecretKeySpec(secretForSecondAccess.getBytes(StandardCharsets.UTF_8), Jwts.SIG.HS256.key().build().getAlgorithm());
        secretKeyForSecondRefresh = new SecretKeySpec(secretForSecondRefresh.getBytes(StandardCharsets.UTF_8), Jwts.SIG.HS256.key().build().getAlgorithm());
    }

    public Long getIdFromAccessToken(String token, boolean flagFirst) {
        if (flagFirst){
            return Jwts.parser().verifyWith(secretKeyForFirstAccess).build().parseSignedClaims(token).getPayload().get("id", Long.class);
        }else{
            return Jwts.parser().verifyWith(secretKeyForSecondAccess).build().parseSignedClaims(token).getPayload().get("id", Long.class);
        }
    }

    public Long getIdFromRefreshToken(String token, boolean flagFirst) {
        if (flagFirst){
            return Jwts.parser().verifyWith(secretKeyForFirstRefresh).build().parseSignedClaims(token).getPayload().get("id", Long.class);
        }else{
            return Jwts.parser().verifyWith(secretKeyForSecondRefresh).build().parseSignedClaims(token).getPayload().get("id", Long.class);
        }
    }

    public String getRole(String token, boolean flagFirst) {
        if (flagFirst){
            return Jwts.parser().verifyWith(secretKeyForFirstAccess).build().parseSignedClaims(token).getPayload().get("role", String.class);
        }else{
            return Jwts.parser().verifyWith(secretKeyForSecondAccess).build().parseSignedClaims(token).getPayload().get("role", String.class);
        }
    }

    public Boolean isAccessTokenExpired(String token, boolean flagFirst) {
        if (flagFirst){
            return Jwts.parser().verifyWith(secretKeyForFirstAccess).build().parseSignedClaims(token).getPayload().getExpiration().before(new Date());
        }else{
            return Jwts.parser().verifyWith(secretKeyForSecondAccess).build().parseSignedClaims(token).getPayload().getExpiration().before(new Date());
        }
    }

    public Boolean isRefreshTokenExpired(String token, boolean flagFirst) {
        if (flagFirst){
            return Jwts.parser().verifyWith(secretKeyForFirstRefresh).build().parseSignedClaims(token).getPayload().getExpiration().before(new Date());
        }else{
            return Jwts.parser().verifyWith(secretKeyForSecondRefresh).build().parseSignedClaims(token).getPayload().getExpiration().before(new Date());
        }
    }

    public String createJwtForAccess(Long id, boolean flagFirst) {
        if (flagFirst){
            return Jwts.builder()
                    .claim("id", id)
                    .claim("role", "ROLE_FIRST_AUTH")
                    .issuedAt(new Date(System.currentTimeMillis()))
                    .expiration(new Date(System.currentTimeMillis() + 60*60*60L))
                    .signWith(secretKeyForFirstAccess)
                    .compact();
        }else{
            return Jwts.builder()
                    .claim("id", id)
                    .claim("role", "ROLE_SECOND_AUTH")
                    .issuedAt(new Date(System.currentTimeMillis()))
                    .expiration(new Date(System.currentTimeMillis() + 60*60*60L))
                    .signWith(secretKeyForSecondAccess)
                    .compact();
        }
    }

    public String createJwtForRefresh(Long id, boolean flagFirst) {
        if (flagFirst){
            return Jwts.builder()
                    .claim("id", id)
                    .issuedAt(new Date(System.currentTimeMillis()))
                    .expiration(new Date(System.currentTimeMillis() + 60*60*60L))
                    .signWith(secretKeyForFirstRefresh)
                    .compact();
        }else{
            return Jwts.builder()
                    .claim("id", id)
                    .issuedAt(new Date(System.currentTimeMillis()))
                    .expiration(new Date(System.currentTimeMillis() + 60*60*60L))
                    .signWith(secretKeyForSecondRefresh)
                    .compact();
        }
    }

    public boolean validateAccessToken(String token, boolean flagFirst){
        if (flagFirst){
            Jws<Claims> claims = Jwts
                    .parser().verifyWith(secretKeyForFirstAccess)
                    .build()
                    .parseSignedClaims(token);
            return true;
        }else{
            Jws<Claims> claims = Jwts
                    .parser().verifyWith(secretKeyForSecondAccess)
                    .build()
                    .parseSignedClaims(token);
            return true;
        }
    }

    public boolean validateRefreshToken(String token, boolean flagFirst){
        if (flagFirst){
            Jws<Claims> claims = Jwts
                    .parser().verifyWith(secretKeyForFirstRefresh)
                    .build()
                    .parseSignedClaims(token);
            return true;
        }else{
            Jws<Claims> claims = Jwts
                    .parser().verifyWith(secretKeyForSecondRefresh)
                    .build()
                    .parseSignedClaims(token);
            return true;
        }
    }

}
