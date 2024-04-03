package com.ssafy.pickachu.domain.statistics.serviceImpl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.datastax.oss.driver.api.core.CqlSession;
import com.datastax.oss.driver.api.core.cql.*;
import com.google.gson.Gson;
import com.ssafy.pickachu.domain.cards.personalcards.dto.RegisterCardsReq;
import com.ssafy.pickachu.domain.cards.personalcards.entity.CodefToken;
import com.ssafy.pickachu.domain.cards.personalcards.entity.PersonalCards;
import com.ssafy.pickachu.domain.cards.personalcards.repository.CodefRepository;
import com.ssafy.pickachu.domain.cards.personalcards.repository.PersonalCardsRepository;
import com.ssafy.pickachu.domain.cards.recommend.entity.CardInfo;
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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
    private final CqlSession cqlSession;

    Map<String, String>  bankInfoExpression = new HashMap<>(){{

        put(".*서양음식.*", "푸드");
        put(".*양식.*", "푸드");
        put(".*중식.*", "푸드");
        put(".*중국음식.*", "푸드");
        put(".*반점.*", "푸드");
        put(".*횟집.*", "푸드");
        put(".*수산.*", "푸드");
        put(".*일식.*", "푸드");
        put(".*일본음식.*", "푸드");
        put(".*한식.*", "푸드");
        put(".*한국음식.*", "푸드");
        put(".*요기요.*", "푸드");
        put(".*배달의민족.*", "푸드");
        put(".*쿠팡이츠.*", "푸드");
        put(".*휴게음식.*", "푸드");
        put(".*패스트푸드.*", "푸드");
        put(".*일반음식점.*", "푸드");
        put(".*위탁급식업.*", "푸드");
        put(".*곡물.*", "푸드");
        put(".*고기.*", "푸드");
        put(".*반찬.*", "푸드");
        put(".*분식.*", "푸드");
        put(".*주류.*", "푸드");
        put(".*급식업.*", "푸드");

        put(".*철   도.*", "교통");
        put(".*철도.*", "교통");
        put(".*카카오택시.*", "교통");
        put(".*운송.*", "교통");
        put(".*교통.*", "교통");
        put(".*주유.*", "교통");
        put(".*바이크.*", "교통");
        put(".*자전거.*", "교통");
        put(".*충전소.*", "교통");
        put(".*정비.*", "교통");

        put(".*Mall.*", "쇼핑");
        put(".*쿠팡.*", "쇼핑");
        put(".*소비.*", "쇼핑");
        put(".*선물.*", "쇼핑");
        put(".*쇼핑.*", "쇼핑");
        put(".*잡화.*", "쇼핑");
        put(".*판매점.*", "쇼핑");
        put(".*공공기관직영점.*", "쇼핑");
        put(".*백화점.*", "쇼핑");

        put(".*약국.*", "의료");
        put(".*치과.*", "의료");
        put(".*의원.*", "의료");
        put(".*내과.*", "의료");
        put(".*외과.*", "의료");
        put(".*소아과.*", "의료");
        put(".*이빈후과.*", "의료");
        put(".*치료.*", "의료");
        put(".*의사.*", "의료");
        put(".*병원.*", "의료");

        put(".*통신.*", "통신");
        put(".*LG.*", "통신");
        put(".*SKT.*", "통신");
        put(".*KT.*", "통신");
        put(".*텔레콤.*", "통신");
        put(".*휴대폰.*", "통신");

        put(".*숙박.*", "여행");
        put(".*모텔.*", "여행");
        put(".*호텔.*", "여행");
        put(".*항공.*", "여행");
        put(".*여객.*", "여행");
        put(".*비행기.*", "여행");
        put(".*렌트.*", "여행");
        put(".*관광.*", "여행");
        put(".*면세.*", "여행");

        put(".*기타.*", "기타");
        put(".*사무서비스.*", "기타");
        put(".*공공기관.*", "기타");

        put(".*도시가스.*", "할인");
        put(".*전기.*", "할인");
        put(".*수도.*", "할인");
        put(".*공과금.*", "할인");

        put(".*노래.*", "문화/생활");
        put(".*영화.*", "문화/생활");
        put(".*사진.*", "문화/생활");
        put(".*안경.*", "문화/생활");
        put(".*상품권.*", "문화/생활");
        put(".*골프.*", "문화/생활");
        put(".*수영.*", "문화/생활");
        put(".*볼링.*", "문화/생활");
        put(".*스키.*", "문화/생활");
        put(".*스포츠.*", "문화/생활");
        put(".*놀이.*", "문화/생활");

        put(".*음료식품.*", "카페");
        put(".*커피.*", "카페");
        put(".*카페.*", "카페");

        put(".*전자상거래.*", "온라인결제");
        put(".*네이버.*", "온라인결제");
        put(".*삼성.*", "온라인결제");
        put(".*애플.*", "온라인결제");
        put(".*구글.*", "온라인결제");
        put(".*전자.*", "온라인결제");
        put(".*P/G.*", "온라인결제");
        put(".*PG.*", "온라인결제");

        put(".*편의점.*", "마트/편의점");
        put(".*GS25.*", "마트/편의점");
        put(".*7ELEVEN.*", "마트/편의점");
        put(".*7-ELEVEN.*", "마트/편의점");
        put(".*7-eleven.*", "마트/편의점");
        put(".*CU.*", "마트/편의점");
        put(".*편 의 점.*", "마트/편의점");
        put(".*슈퍼마켓.*", "마트/편의점");
        put("마트", "마트/편의점");

    }};

    Gson gson = new Gson();
    CommonUtil commonUtil = new CommonUtil();
    @Override
    public void saveCardHistories(String payListResult, User user, long cardId) {

        String userAgeGroup = commonUtil.calculateAge(user.getBirth());

        // 문자열 내용을 JSONArray 객체로 변환
        JSONArray jsonArray = new JSONArray(payListResult);

        // JSONArray 내용 처리 예시
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject = (JSONObject) jsonArray.get(i);
            CardHistoryEntity history = gson.fromJson(String.valueOf(jsonObject), CardHistoryEntity.class);
            // 혹시 일치하는 것이 없으면 기타로 넘기기
            history.setCategory("기타");
            for (String key : bankInfoExpression.keySet()) {
                Pattern pattern = Pattern.compile(key);
                Matcher matcher = pattern.matcher(history.getCategory());
                if(matcher.find()){
                    history.setCategory(bankInfoExpression.get(key));
                    break;
                }
            }

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
        calendar.add(Calendar.DATE, -1);
        String startDay = dateFormat.format(calendar.getTime());
        String endDay = startDay;

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

    public String CalculateBenefit(CardInfo cards, List<CardHistoryEntity> cardHistoryEntities){
        Map<String, List<Object>> contents = cards.getContents();
        List<String> keys = cards.getCategories();
        List<String> groups = cards.getGroupCategory();
        Map<String, Integer> totalDiscount = new HashMap<>();
        for (CardHistoryEntity cardHistoryEntity : cardHistoryEntities) {
            String category = cardHistoryEntity.getCategory();
            int idxCat = groups.indexOf(category);
            if (idxCat < 0){
                continue;
            }
            Map<String, Object> tt;
            try{
                tt= (Map<String, Object>) contents.get(keys.get(idxCat)).get(1);
            }catch (NullPointerException ignore){
                continue;
            }

            int disCountValue = 0;

            if (tt.get("payType").equals("%")){
                double discount = ((Integer) tt.get("discount")) / 100.0;
                double amount = (double) cardHistoryEntity.getAmount();
                disCountValue = (int) (amount * discount);

            }else if (tt.get("payType").equals("원")){
                int unit = (int)tt.get("unit");
                if(unit != 0 && cardHistoryEntity.getAmount() > unit){
                    disCountValue = (int)tt.get("discount");
                }else if (unit == 0){
                    disCountValue = (int)tt.get("discount");
                }else{
                    disCountValue = 0;
                }
            }
            int totalValue = totalDiscount.getOrDefault(category, 0) + disCountValue;
            totalDiscount.put(category, totalValue);

        }
        Map<String, Integer> sortedMap = new LinkedHashMap<>();
        totalDiscount.entrySet().stream()
            .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
            .forEachOrdered(x -> sortedMap.put(x.getKey(), x.getValue()));

        try {
            return new ObjectMapper().writeValueAsString(sortedMap);
        } catch (JsonProcessingException e) {
            return null;
        }
    }

}
