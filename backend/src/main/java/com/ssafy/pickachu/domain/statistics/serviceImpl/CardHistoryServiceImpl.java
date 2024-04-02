package com.ssafy.pickachu.domain.statistics.serviceImpl;

import com.google.gson.Gson;
import com.ssafy.pickachu.domain.cards.personalcards.dto.RegisterCardsReq;
import com.ssafy.pickachu.domain.cards.personalcards.entity.CodefToken;
import com.ssafy.pickachu.domain.cards.personalcards.entity.PersonalCards;
import com.ssafy.pickachu.domain.cards.personalcards.repository.CodefRepository;
import com.ssafy.pickachu.domain.cards.personalcards.repository.PersonalCardsRepository;
import com.ssafy.pickachu.domain.statistics.entity.CardHistoryEntity;
import com.ssafy.pickachu.domain.statistics.exception.CardInfoIOException;
import com.ssafy.pickachu.domain.statistics.exception.InvalidApiKeyException;
import com.ssafy.pickachu.domain.statistics.repository.CardHistoryEntityRepository;
import com.ssafy.pickachu.domain.statistics.response.CardHistoryRes;
import com.ssafy.pickachu.domain.statistics.service.CardHistoryService;
import com.ssafy.pickachu.domain.user.entity.User;
import com.ssafy.pickachu.domain.user.repository.UserRepository;
import com.ssafy.pickachu.global.codef.CodefApi;
import com.ssafy.pickachu.global.util.CommonUtil;
import com.ssafy.pickachu.global.util.JasyptUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class CardHistoryServiceImpl implements CardHistoryService {

    private final String apiKey = "ssafyj10d110aairflow"; // 추후 따로 빼거나 암호화
    private final CardHistoryEntityRepository cardHistoryEntityRepository;
    private final UserRepository userRepository;
    private final CodefRepository codefRepository;
    private final PersonalCardsRepository personalCardsRepository;
    private final CodefApi codefApi;
    private final JasyptUtil jasyptUtil;

    Gson gson = new Gson();
    CommonUtil commonUtil = new CommonUtil();
    @Override
    public void saveCardHistories(String payListResult, User user, long cardId) {

//        int myAge = LocalDateTime.now().getYear() - user.getBirth().getYear();
//        String age = (myAge / 10) + "대";
        String userAgeGroup = commonUtil.calculateAge(user.getBirth());

        // 문자열 내용을 JSONArray 객체로 변환
        JSONArray jsonArray = new JSONArray(payListResult);

        // JSONArray 내용 처리 예시
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject = (JSONObject) jsonArray.get(i);

            CardHistoryEntity history = gson.fromJson(String.valueOf(jsonObject), CardHistoryEntity.class);
            history.setUserid((int) user.getId());
            history.setId(UUID.randomUUID());
            history.setGender(user.getGender());
            history.setAge(userAgeGroup);
            history.setCardId((int) cardId);
            cardHistoryEntityRepository.save(history);
        }
    }

    @Override
    public ResponseEntity<CardHistoryRes> saveCardHistoriesByAirflow(String apiKey) {

        // API KEY 검증
        if(!apiKey.equals(this.apiKey)){
            throw new InvalidApiKeyException("API Key가 일치하지 않습니다.");
        }

        // 유저 전체에 대해서 데이터 요청
        List<User> userList = userRepository.findAll();
        CodefToken codefToken = codefRepository.findById(1)
                .orElseGet(() -> {
                    CodefToken token = CodefToken.builder()
                            .id(1)
                            .token(codefApi.GetToken())
                            .updateTime(LocalDateTime.now())
                            .build();
                    return  token;
                });

        // 어제 하루 내역 불러오기
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        String endDay = dateFormat.format(calendar.getTime());

        calendar.add(Calendar.DATE, -1);
        String startDay = dateFormat.format(calendar.getTime());


        // 유저별로
        for(User user : userList){
            try{
                // 카드별로
                List<PersonalCards> personalCards = personalCardsRepository.findAllByUserIdAndUseYN(user.getId(), user.getUseYN());
                for(PersonalCards card : personalCards){
                    RegisterCardsReq registerCardsReq = new RegisterCardsReq(
                        card.getCardCompany(), jasyptUtil.decrypt(card.getCardNo()), jasyptUtil.decrypt(card.getCardCompanyId()), jasyptUtil.decrypt(card.getCardCompanyPw())
                    );
                    String payListResult = codefApi.GetUseCardList(registerCardsReq, user, codefToken.getToken(),startDay,endDay);
                    saveCardHistories(payListResult, user, card.getId());
                }
            }catch (IOException e){
                throw new CardInfoIOException("카드 정보를 가져오는 데 문제가 발생했습니다.");
            }catch (Exception e){
                e.printStackTrace();
            }

        }


        CardHistoryRes cardHistoryRes = CardHistoryRes.createCardHistoryResponse(
                HttpStatus.OK.value(), "Success", "Success"
        );

        return ResponseEntity.ok(cardHistoryRes);
    }



}
