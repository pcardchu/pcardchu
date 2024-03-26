package com.ssafy.pickachu.domain.user.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.pickachu.domain.user.dto.BasicInfoDto;
import com.ssafy.pickachu.domain.user.dto.IdTokenDto;
import com.ssafy.pickachu.domain.user.dto.KakaoPayloadDto;
import com.ssafy.pickachu.domain.user.entity.User;
import com.ssafy.pickachu.domain.user.exception.UserNotFoundException;
import com.ssafy.pickachu.domain.user.repository.UserRepository;
import com.ssafy.pickachu.domain.auth.jwt.JwtUtil;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.sql.Date;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService{

    private final JwtUtil jwtUtil;
    private final UserRepository userRepository;

    @Value("${key.idtoken}")
    String idTokenKey; // 16자리의 키

    @Override
    public Map<String, Object> loginWithKakao(IdTokenDto idTokenDto) {

        // idToken 얻기
        String idToken = decryptAES(idTokenDto);

        // idToken Kakao 검증

        // idToken payload로 유저 정보 얻기
        KakaoPayloadDto kakaoPayloadDto = getPayload(idToken);
        User user = userRepository.findByIdentifier("kakao_"+kakaoPayloadDto.getSub());

        Map<String, Object> result = new HashMap<>();

        if(user == null){
            user = User.builder()
                    .email(kakaoPayloadDto.getEmail())
                    .nickname(kakaoPayloadDto.getNickname())
                    .provider("kakao")
                    .identifier("kakao_"+kakaoPayloadDto.getSub())
                    .role("ROLE_USER").build();
            userRepository.save(user);

            result.put("flag_basicInfo", false);
        }else{
            if (user.getShortPw() == null){
                result.put("flag_basicInfo", false);
            }
            result.put("flag_basicInfo", true);
        }

        String jwtToken = jwtUtil.createJwt(user.getId(),60*60*60L, true);
        result.put("jwt", jwtToken);

        // 1차 JWT 발급
        return result;
    }

    @Transactional
    @Override
    public boolean updateBasicInfo(Long id, BasicInfoDto basicInfoDto) {
        if (!basicInfoDto.getGender().equals("M") && !basicInfoDto.getGender().equals("F")){
            return false;
        }else{
            User user = userRepository.findById(id)
                    .orElseThrow(() -> new UserNotFoundException());

            user.setGender(basicInfoDto.getGender());
            user.setBirth(basicInfoDto.getBirth());
            user.setShortPw(basicInfoDto.getShortPw());

            return true;
        }
    }

    @Transactional
    @Override
    public boolean updateGender(Long id, String gender) {
        if (!gender.equals("M") && !gender.equals("F")){
            return false;
        }else{
            User user = userRepository.findById(id)
                    .orElseThrow(() -> new UserNotFoundException());

            user.setGender(gender);
            return true;
        }
    }

    @Transactional
    @Override
    public boolean updateBirth(Long id, Date birth) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException());

        user.setBirth(birth);
        return true;
    }




    private String decryptAES(IdTokenDto idTokenDto){

        String base64IV = idTokenDto.getBase64IV();
        String encryptedIdToken = idTokenDto.getEncryptedIdToken();

        byte[] initVector = Base64.getDecoder().decode(base64IV);
        byte[] encryptedString = Base64.getDecoder().decode(encryptedIdToken);
        byte[] aesKey = Base64.getDecoder().decode(idTokenKey);

        String decryptedString = null;

        try {
            IvParameterSpec iv = new IvParameterSpec(initVector);
            SecretKeySpec skeySpec = new SecretKeySpec(aesKey, "AES");

            Cipher cipher = Cipher.getInstance("AES/CTR/NoPadding");
            cipher.init(Cipher.DECRYPT_MODE, skeySpec, iv);

            byte[] original = cipher.doFinal(encryptedString);

            decryptedString = new String(original);

        }catch(Exception e){
            e.printStackTrace();
            return null;
        }

        return decryptedString;
    }

    private KakaoPayloadDto getPayload(String idToken){
        ObjectMapper objectMapper = new ObjectMapper();

//        idToken = "eyJraWQiOiI5ZjI1MmRhZGQ1ZjIzM2Y5M2QyZmE1MjhkMTJmZWEiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJjMTVkYjhlZDRkZDNmZjljNTI0YzljYjRjNGJkNzdiZSIsInN1YiI6IjMzNzk5NzQyMzAiLCJhdXRoX3RpbWUiOjE3MTEzNDM5OTUsImlzcyI6Imh0dHBzOi8va2F1dGgua2FrYW8uY29tIiwibmlja25hbWUiOiLsnbTssL3qs6QiLCJleHAiOjE3MTEzODcxOTUsImlhdCI6MTcxMTM0Mzk5NSwicGljdHVyZSI6Imh0dHA6Ly9rLmtha2FvY2RuLm5ldC9kbi9ieVZCTkwvYnRzRDRFWDN1dXovamdmRUdZQ3YxdlVQUHJQZTZlNmZPay9pbWdfMTEweDExMC5qcGciLCJlbWFpbCI6ImNrZGRsOTcwMTEwQGdtYWlsLmNvbSJ9.ntuHrHv38YXzq-pfIXjyOJZZANkexxnoCxOavxhYW-JiRs2e6ogW9PA2TjHgQd-2X7XcVT5ZL4SmKx13cjrGZehdrMaCygbcSwmFJI4qPriNR-SvQr2REowKCbXJPd18yPdaMVvLNBiOkIhORl6SnFVMGorgf4r-H6Du9h81k_KXGC5oys1QEJckw9fIRbai5OSexxf7fPZZx-lqi8rZEBDwenC-T13CFQg_7YBygKFlcqEaRd0Y7x9khYKTiuVQe_zqrObV5Wao4uCwMFH3h2WC3upJPbwxZ5HdqzOjI4bUYKDH7CI_AsftcJwa7lqCTEMFQcp4-NS7-bJTrd-tyw";

        String[] token = idToken.split("\\.");
        byte[] payload = Base64.getDecoder().decode(token[1]);
        String json = new String(payload);

        KakaoPayloadDto kakaoPayloadDto = null;

        try {
            kakaoPayloadDto = objectMapper.readValue(json, KakaoPayloadDto.class);
        }catch (Exception e){
            System.out.println(e);
        }


        return kakaoPayloadDto;
    }
}
