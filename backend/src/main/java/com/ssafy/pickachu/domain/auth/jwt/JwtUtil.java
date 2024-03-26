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
    private SecretKey secretKey1;
    private SecretKey secretKey2;

    public JwtUtil(@Value("${key.first-jwt}") String secret1,
                   @Value("${key.second-jwt}") String secret2) {
        secretKey1 = new SecretKeySpec(secret1.getBytes(StandardCharsets.UTF_8), Jwts.SIG.HS256.key().build().getAlgorithm());
        secretKey2 = new SecretKeySpec(secret2.getBytes(StandardCharsets.UTF_8), Jwts.SIG.HS256.key().build().getAlgorithm());
    }

    public Long getId(String token, boolean flagFirst) {
        if (flagFirst){
            return Jwts.parser().verifyWith(secretKey1).build().parseSignedClaims(token).getPayload().get("id", Long.class);
        }else{
            return Jwts.parser().verifyWith(secretKey2).build().parseSignedClaims(token).getPayload().get("id", Long.class);

        }
    }

    public String getRole(String token, boolean flagFirst) {
        if (flagFirst){
            return Jwts.parser().verifyWith(secretKey1).build().parseSignedClaims(token).getPayload().get("role", String.class);
        }else{
            return Jwts.parser().verifyWith(secretKey2).build().parseSignedClaims(token).getPayload().get("role", String.class);
        }
    }

    public Boolean isExpired(String token, boolean flagFirst) {
        if (flagFirst){
            return Jwts.parser().verifyWith(secretKey1).build().parseSignedClaims(token).getPayload().getExpiration().before(new Date());
        }else{
            return Jwts.parser().verifyWith(secretKey2).build().parseSignedClaims(token).getPayload().getExpiration().before(new Date());
        }
    }

    public String createJwt(Long id, Long expiredMs, boolean flagFirst) {
        if (flagFirst){
            return Jwts.builder()
                    .claim("id", id)
                    .claim("role", "ROLE_FIRST_AUTH")
                    .issuedAt(new Date(System.currentTimeMillis()))
                    .expiration(new Date(System.currentTimeMillis() + expiredMs))
                    .signWith(secretKey1)
                    .compact();
        }else{
            return Jwts.builder()
                    .claim("id", id)
                    .claim("role", "ROLE_SECOND_AUTH")
                    .issuedAt(new Date(System.currentTimeMillis()))
                    .expiration(new Date(System.currentTimeMillis() + expiredMs))
                    .signWith(secretKey2)
                    .compact();
        }

    }

    public boolean validateToken(String token, boolean flagFirst){
        if (flagFirst){
            Jws<Claims> claims = Jwts
                    .parser().verifyWith(secretKey1)
                    .build()
                    .parseSignedClaims(token);
            return true;
        }else{
            Jws<Claims> claims = Jwts
                    .parser().verifyWith(secretKey2)
                    .build()
                    .parseSignedClaims(token);
            return true;
        }

    }
}
