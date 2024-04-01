package com.ssafy.pickachu.domain.cards.personalcards.service;

import com.ssafy.pickachu.domain.auth.PrincipalDetails;
import com.ssafy.pickachu.domain.auth.jwt.JwtUtil;
import com.ssafy.pickachu.domain.cards.personalcards.dto.RegisterCardsReq;
import com.ssafy.pickachu.domain.cards.personalcards.dto.SimplePersonalCardsRes;
import com.ssafy.pickachu.domain.cards.personalcards.entity.CodefToken;
import com.ssafy.pickachu.domain.cards.personalcards.entity.PersonalCards;
import com.ssafy.pickachu.domain.cards.personalcards.mapper.PersonalCardsMapper;
import com.ssafy.pickachu.domain.cards.personalcards.repository.CodefRepository;
import com.ssafy.pickachu.domain.cards.personalcards.repository.PersonalCardsRepository;
import com.ssafy.pickachu.domain.cards.recommend.entity.Cards;
import com.ssafy.pickachu.domain.cards.recommend.repository.CardsRepository;
import com.ssafy.pickachu.domain.statistics.service.CardHistoryService;
import com.ssafy.pickachu.domain.user.entity.User;
import com.ssafy.pickachu.domain.user.repository.UserRepository;
import com.ssafy.pickachu.global.codef.CodefApi;
import com.ssafy.pickachu.global.exception.ErrorCode;
import com.ssafy.pickachu.global.exception.ErrorException;
import com.ssafy.pickachu.global.exception.ErrorResponse;
import com.ssafy.pickachu.global.util.JasyptUtil;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import com.google.gson.Gson;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.*;


@Transactional
@Slf4j
@RequiredArgsConstructor
@Service
public class PersonalCardsServiceImpl implements PersonalCardsService {

    private final PersonalCardsRepository personalCardsRepository;
    private final CardsRepository cardsRepository;
    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;
    private final PersonalCardsMapper personalCardsMapper;
    private final CodefRepository codefRepository;
    private final CodefApi codefApi;
    private final EntityManager em;
    private final CardHistoryService cardHistoryService;
    private final JasyptUtil jasyptUtil;
    @Override
    public void DeleteMyCards(String cardid) {
        //TODO  TestUser CODE 여기 jwt 토큰을 이용한 멤버 받아오기 코드가 들어와야함
        User users = User.builder().build();
        int userId = 1;

        PersonalCards personalCards = personalCardsRepository.findPersonalCardsByUserIdAndCardsId(userId, cardid)
            .orElseThrow(() -> new ErrorException(ErrorCode.USER_NOT_FOUND));

        if(users.getId() != personalCards.getUserId()){
            throw new RuntimeException("not match user");
        }
        personalCards.setUseYN("N");
        personalCardsRepository.save(personalCards);
    }

    @Override
    public List<SimplePersonalCardsRes> GetPersonalCardsList(PrincipalDetails principalDetails) {

        User user = userRepository.findById(principalDetails.getUserDto().getId())
            .orElseThrow(() -> new ErrorException(ErrorCode.USER_NOT_FOUND));

        List<SimplePersonalCardsRes> simplePersonalCardsRes = new ArrayList<>();

        List<PersonalCards> personalCardsList = personalCardsRepository.findAllByUserIdAndUseYN(user.getId(), "Y");
        personalCardsList.forEach(personalCards -> {
            SimplePersonalCardsRes tmpRes = personalCardsMapper.toSimplePersonalCardsRes(personalCards);
            Optional<Cards> cards = cardsRepository.findById(personalCards.getCardsId());
            cards.ifPresent(card -> tmpRes.setCardImage(card.getImageUrl()));
            simplePersonalCardsRes.add(tmpRes);
        });
        return simplePersonalCardsRes;
    }

    @Override
    public void RegisterMyCards(PrincipalDetails principalDetails, RegisterCardsReq registerCardsReq) {
        Gson gson = new Gson();
        // Codef Token 가져오기/생성
        CodefToken codefToken = codefRepository.findById(1)
            .orElseGet(() -> {
                CodefToken token = CodefToken.builder()
                    .id(1)
                    .token(codefApi.GetToken())
                    .updateTime(LocalDateTime.now())
                    .build();
                return  token;
            });
        codefRepository.saveAndFlush(codefToken);

        User user = userRepository.findById(principalDetails.getUserDto().getId())
            .orElseThrow(() -> new ErrorException(ErrorCode.USER_NOT_FOUND));


//      토큰 시간 지났으면 갱신
        if (codefToken.getUpdateTime().plusDays(7).isBefore(LocalDateTime.now())) {
            codefToken.setToken(codefApi.GetToken());
            codefRepository.save(codefToken);
        }


        // XXX 유저에게 connectedId 존재 여부 확인

        if (user.getConnectedId() == null) {
            // XXX ConnectedId 추가하기
            try {
                String newConnectedId = codefApi.GetConnectedToken(registerCardsReq, codefToken.getToken());
                user.setConnectedId(jasyptUtil.encrypt(newConnectedId));


            } catch (NoSuchPaddingException | IllegalBlockSizeException | NoSuchAlgorithmException |
                     InvalidKeySpecException | BadPaddingException | InvalidKeyException | IOException |
                     ParseException | InterruptedException ignore) {
            }
        }else {
            //TODO 여기 .. ..... . . . . 퍼스널 카드 목록에 그 은행이 있는지 확인 없으면 ... connectedID 갱신
            List<String> userRegistCompanyList = personalCardsRepository.getPersonalCardsCardCompanyListByuser(user.getId());
            if (!userRegistCompanyList.contains(registerCardsReq.getCardCompany())) {
                log.info("connectedId add Bank : " + registerCardsReq.getCardCompany());
                try {
                    String newConnectedId = codefApi.AddBankInConnectedId(registerCardsReq, user, codefToken.getToken());
                    if(!newConnectedId.equals("existBankData")){
                        throw new ErrorException(ErrorCode.EXIST_BANK_INFO);
                    }
                    user.setConnectedId(jasyptUtil.encrypt(newConnectedId));
                } catch (NoSuchPaddingException | IllegalBlockSizeException | NoSuchAlgorithmException |
                         InvalidKeySpecException | BadPaddingException | InvalidKeyException | IOException |
                         ParseException | InterruptedException ignore) {
                }
            }
        }

        //TODO 카드 이름 넣어야 detail 조회가 가능하다..
        String userCards;
        try {
            userCards = codefApi.GetCardsName(registerCardsReq, user, codefToken.getToken());

        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        JSONObject usercardsJson = new JSONObject(userCards);
        JSONArray cardsListArray = (JSONArray) usercardsJson.get("data");

        String cardNameTarget = "Card";
        for (Object o : cardsListArray) {

            Map<String, String> o1 = gson.fromJson(o.toString(), Map.class);
            String maskedStr1 = o1.get("resCardNo");
            String maskedStr2 = registerCardsReq.getCardNo().replace("-", "");
            int matchingChars = 0;
            for (int i = 0; i < maskedStr1.length(); i++) {
                if (maskedStr1.charAt(i) == maskedStr2.charAt(i)) {
                    matchingChars++;
                }
            }

            maskedStr1 = maskedStr1.replaceAll("\\*", "");
            if(maskedStr2.length() - (maskedStr2.length()-maskedStr1.length()) == matchingChars){
                cardNameTarget = o1.get("resCardName");
                break;
            }
        }
        String cardsIdTarget = "0000";
        Optional<Cards> optionalCards = cardsRepository.findByCardName(cardNameTarget);
        if (optionalCards.isPresent()){
            cardsIdTarget = optionalCards.get().getCardName();
        }

        // url 주소 : https://development.codef.io/v1/kr/card/p/account/result-check-list
// 카드 저장.. 이거. 안될것 같은데
        PersonalCards personalCards = PersonalCards.builder()
            .name(cardNameTarget)
            .cardCompany(registerCardsReq.getCardCompany())
            .cardNo(jasyptUtil.encrypt(registerCardsReq.getCardNo()))
            .userId(user.getId())
            .cardCompanyId(jasyptUtil.encrypt(registerCardsReq.getCardCompanyId()))
            .cardCompanyPw(jasyptUtil.encrypt(registerCardsReq.getCardCompanyPw()))
            .cardsId(cardsIdTarget)
            .build();
        personalCardsRepository.saveAndFlush(personalCards);



        // 현재 날짜를 가져오기
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");

        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.add(Calendar.DAY_OF_MONTH, -1); // 저번달 마지막날로 이동
        String endDay = dateFormat.format(calendar.getTime());

        calendar.set(Calendar.DAY_OF_MONTH, 1);   // 지난달 1일로 이동
        String startDay = dateFormat.format(calendar.getTime());

//        // TODO 사용내역 가지고 오기
        try {
            String payListResult = codefApi.GetUseCardList(registerCardsReq, user, codefToken.getToken(),startDay,endDay);
            cardHistoryService.saveCardHistories(payListResult, user, personalCards.getId());
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        userRepository.save(user);
    }
}
