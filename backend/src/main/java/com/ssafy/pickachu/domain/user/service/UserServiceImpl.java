package com.ssafy.pickachu.domain.user.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.pickachu.domain.user.dto.UserInfoDto;
import com.ssafy.pickachu.domain.user.exception.TokenNotMatchedException;
import com.ssafy.pickachu.domain.user.request.BasicInfoReq;
import com.ssafy.pickachu.domain.user.request.IdTokenReq;
import com.ssafy.pickachu.domain.user.dto.KakaoPayloadDto;
import com.ssafy.pickachu.domain.user.entity.User;
import com.ssafy.pickachu.domain.user.exception.UserNotFoundException;
import com.ssafy.pickachu.domain.user.repository.UserRepository;
import com.ssafy.pickachu.domain.auth.jwt.JwtUtil;
import com.ssafy.pickachu.domain.user.request.TokenReissueReq;
import com.ssafy.pickachu.domain.user.response.FirstTokenRes;
import com.ssafy.pickachu.domain.user.response.SecondTokenRes;
import com.ssafy.pickachu.domain.user.response.UserInfoRes;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService{

    private final JwtUtil jwtUtil;
    private final UserRepository userRepository;
    private final EmailService emailService;

    @Value("${key.idtoken}")
    String idTokenKey; // 16자리의 키

    @Transactional
    @Override
    public Map<String, Object> loginWithKakao(IdTokenReq idTokenReq) {

        // idToken 얻기
        String idToken = decryptAES(idTokenReq);

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
                    .role("ROLE_USER")
                    .flagBiometrics(0)
                    .pwWrongCount(0).build();
            userRepository.save(user);

            result.put("flag_basicInfo", false);
            log.info("신규 유저, 추가 정보 없음");
        }else{
            if (user.getShortPw() == null){
                result.put("flag_basicInfo", false);
                log.info("기존 유저, 추가 정보 없음");
            }else{
                result.put("flag_basicInfo", true);
                log.info("기존 유저, 추가 정보 있음");
            }
        }

        String accessToken = jwtUtil.createJwtForAccess(user.getId(), true);
        String refreshToken = jwtUtil.createJwtForRefresh(user.getId(), true);

        user.setFirstRefreshToken(refreshToken);

        FirstTokenRes firstTokenRes = FirstTokenRes.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .flagBiometrics(user.getFlagBiometrics()).build();

        result.put("tokenAndFlag", firstTokenRes);

        // 1차 JWT 발급
        return result;
    }

    @Transactional
    @Override
    public Map<String, Object> loginWithPassword(Long id, String shortPw) {

        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException());

        Map<String, Object> result = new HashMap<>();

        if (user.getPwWrongCount() == 5){
            result.put("result", false);
            result.put("wrongCount", user.getPwWrongCount());
        }else if (!user.getShortPw().equals(shortPw)){
            user.setPwWrongCount(user.getPwWrongCount()+1);

            result.put("result", false);
            result.put("wrongCount", user.getPwWrongCount());
        }else {
            result.put("result", true);
            user.setPwWrongCount(0);

            String accessToken = jwtUtil.createJwtForAccess(user.getId(), false);
            String refreshToken = jwtUtil.createJwtForRefresh(user.getId(), false);

            user.setSecondRefreshToken(refreshToken);

            SecondTokenRes secondTokenRes = SecondTokenRes.builder()
                    .accessToken(accessToken)
                    .refreshToken(refreshToken
                    ).build();

            result.put("token", secondTokenRes);
        }

        return result;
    }

    @Override
    public Map<String, Object> loginWithBio(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException());

        Map<String, Object> result = new HashMap<>();

        if (user.getFlagBiometrics() == 0){
            result.put("result", false);
        }else {
            result.put("result", true);

            String accessToken = jwtUtil.createJwtForAccess(user.getId(), false);
            String refreshToken = jwtUtil.createJwtForRefresh(user.getId(), false);

            user.setSecondRefreshToken(refreshToken);

            SecondTokenRes secondTokenRes = SecondTokenRes.builder()
                    .accessToken(accessToken)
                    .refreshToken(refreshToken
                    ).build();

            result.put("token", secondTokenRes);
        }

        return result;
    }

    @Override
    public SecondTokenRes reissueToken(TokenReissueReq tokenReissueReq) {

        String token = tokenReissueReq.getRefreshToken();
        boolean isFlagFirst = tokenReissueReq.isFlagFirst();

        jwtUtil.validateRefreshToken(token, isFlagFirst);

        Long id = jwtUtil.getIdFromRefreshToken(token, isFlagFirst);
        User user = userRepository.findById(id)
                .orElseThrow(UserNotFoundException::new);

        String accessToken = "";
        String refreshToken = "";

        if (isFlagFirst){
            if (user.getFirstRefreshToken().equals(token)){
                accessToken = jwtUtil.createJwtForAccess(user.getId(), isFlagFirst);
                refreshToken = jwtUtil.createJwtForRefresh(user.getId(), isFlagFirst);

                user.setFirstRefreshToken(refreshToken);
            }else{
                throw new TokenNotMatchedException();
            }
        }else{
            if (user.getSecondRefreshToken().equals(token)){
                accessToken = jwtUtil.createJwtForAccess(user.getId(), isFlagFirst);
                refreshToken = jwtUtil.createJwtForRefresh(user.getId(), isFlagFirst);

                user.setSecondRefreshToken(refreshToken);
            }else{
                throw new TokenNotMatchedException();
            }
        }

        SecondTokenRes secondTokenRes = SecondTokenRes.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken).build();

        return secondTokenRes;
    }

    @Transactional
    @Override
    public boolean updateBasicInfo(Long id, BasicInfoReq basicInfoReq) {
        if (!basicInfoReq.getGender().equals("남성") && !basicInfoReq.getGender().equals("여성")){
            return false;
        }else{
            User user = userRepository.findById(id)
                    .orElseThrow(() -> new UserNotFoundException());

            user.setGender(basicInfoReq.getGender());
            user.setBirth(basicInfoReq.getBirth());
            user.setShortPw(basicInfoReq.getShortPw());

            log.info("추가 정보 입력 완료");

            return true;
        }
    }

    @Override
    public UserInfoRes getUserInfo(Long id) {
        UserInfoDto userInfoDto = userRepository.getUserInfo(id);
        return userInfoDto.toUserInfoRes();
    }

    @Transactional
    @Override
    public boolean updateFlagBiometrics(Long id, boolean flagBiometrics) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException());

        if (flagBiometrics){
            user.setFlagBiometrics(1);
        }else {
            user.setFlagBiometrics(0);
        }

        return true;
    }

    @Transactional
    @Override
    public boolean updateShortPw(Long id, String shortPw) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException());

        user.setShortPw(shortPw);
        return true;
    }

    @Transactional
    @Override
    public boolean updateGender(Long id, String gender) {
        if (!gender.equals("남성") && !gender.equals("여성")){
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

    @Override
    public boolean sendEmail(Long id) {
        return emailService.sendEmail(id);
    }


    private String decryptAES(IdTokenReq idTokenReq){

        String base64IV = idTokenReq.getBase64IV();
        String encryptedIdToken = idTokenReq.getEncryptedIdToken();

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
