package com.ssafy.pickachu.domain.cards.personalcards.service;

import com.datastax.oss.driver.shaded.guava.common.reflect.TypeToken;
import com.ssafy.pickachu.domain.auth.PrincipalDetails;
import com.ssafy.pickachu.domain.auth.jwt.JwtUtil;
import com.ssafy.pickachu.domain.cards.personalcards.dto.*;
import com.ssafy.pickachu.domain.cards.personalcards.entity.CodefToken;
import com.ssafy.pickachu.domain.cards.personalcards.entity.PersonalCards;
import com.ssafy.pickachu.domain.cards.personalcards.mapper.PersonalCardsMapper;
import com.ssafy.pickachu.domain.cards.personalcards.repository.CodefRepository;
import com.ssafy.pickachu.domain.cards.personalcards.repository.PersonalCardsRepository;
import com.ssafy.pickachu.domain.cards.recommend.dto.SimpleCard;
import com.ssafy.pickachu.domain.cards.recommend.entity.CardInfo;
import com.ssafy.pickachu.domain.cards.recommend.entity.Cards;
import com.ssafy.pickachu.domain.cards.recommend.repository.CardInfoRepository;
import com.ssafy.pickachu.domain.cards.recommend.repository.CardsAggregation;
import com.ssafy.pickachu.domain.cards.recommend.repository.CardsRepository;
import com.ssafy.pickachu.domain.statistics.dto.SimpleCardHistory;
import com.ssafy.pickachu.domain.statistics.entity.CardHistoryEntity;
import com.ssafy.pickachu.domain.statistics.mapper.StatisticsMapper;
import com.ssafy.pickachu.domain.statistics.repository.CardHistoryEntityRepository;
import com.ssafy.pickachu.domain.statistics.service.CardHistoryService;
import com.ssafy.pickachu.domain.user.entity.User;
import com.ssafy.pickachu.domain.user.repository.UserRepository;
import com.ssafy.pickachu.global.codef.CodefApi;
import com.ssafy.pickachu.global.exception.ErrorCode;
import com.ssafy.pickachu.global.exception.ErrorException;
import com.ssafy.pickachu.global.util.JasyptUtil;
import jakarta.persistence.EntityManagerFactory;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import com.google.gson.Gson;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.IOException;
import java.lang.reflect.Type;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;


@Slf4j
@RequiredArgsConstructor
@Service
public class PersonalCardsServiceImpl implements PersonalCardsService {

    private final PersonalCardsRepository personalCardsRepository;
    private final CardsRepository cardsRepository;
    private final CardInfoRepository cardInfoRepository;
    private final UserRepository userRepository;
    private final CardHistoryEntityRepository cardHistoryRepository;
    private final JwtUtil jwtUtil;
    private final PersonalCardsMapper personalCardsMapper;
    private final CodefRepository codefRepository;
    private final CodefApi codefApi;

    private final CardHistoryService cardHistoryService;
    private final JasyptUtil jasyptUtil;
    private final StatisticsMapper statisticsMapper;
    private final CardsAggregation cardsAggregation;

    private final String zeppelinUrl = "<zeppelin server url>:18888";
    private RestTemplate restTemplate = new RestTemplate();

    private void runNotebook() {
        String endpoint = zeppelinUrl + "/api/notebook/job/2JSXPJ6AT";
        restTemplate.postForObject(endpoint, null, Map.class);
    }


    private static Map<String, String> crawlingCategories = new HashMap<>(){{
        put("점심", "푸드");
        put("배달앱", "푸드");
        put("대중교통", "교통");
        put("편의점", "마트/편의점");
        put("온라인쇼핑", "쇼핑");
        put("드럭스토어", "의료");
        put("통신", "통신");
        put("디지털구독", "온라인결제");
        put("대한항공", "여행");
        put("무이자할부", "할인");
        put("프리미엄 서비스", "기타");
        put("유의사항", "기타");
        put("할인", "할인");
        put("무실적", "기타");
        put("모든가맹점", "푸드");
        put("쇼핑", "쇼핑");
        put("영화/문화", "문화/생활");
        put("생활", "문화/생활");
        put("골프", "문화/생활");
        put("적립", "할인");
        put("아시아나항공", "여행");
        put("일반음식점", "푸드");
        put("기타", "기타");
        put("간편결제", "쇼핑");
        put("푸드", "푸드");
        put("교통", "교통");
        put("해외", "여행");
        put("카페", "카페");
        put("해외이용", "쇼핑");
        put("제휴/PLCC", "기타");
        put("충전소", "주유");
        put("멤버십포인트", "할인");
        put("KT", "통신");
        put("주유소", "주유");
        put("카페/디저트", "카페");
        put("백화점", "쇼핑");
        put("대형마트", "마트/마트/편의점");
        put("패밀리레스토랑", "푸드");
        put("보험사", "문화/생활");
        put("프리미엄", "기타");
        put("교육/육아", "문화/생활");
        put("주유", "주유");
        put("테마파크", "문화/생활");
        put("영화", "문화/생활");
        put("게임", "문화/생활");
        put("선택형1", "선택형1");
        put("마트/편의점", "마트/편의점");
        put("홈쇼핑", "쇼핑");
        put("베이커리", "카페");
        put("소셜커머스", "쇼핑");
        put("여행/숙박", "여행");
        put("택시", "교통");
        put("공항라운지", "여행");
        put("수수료우대", "할인");
        put("삼성페이", "온라인결제");
        put("바우처", "문화/생활");
        put("선택형2", "선택형2");
        put("선택형3", "선택형3");
        put("네이버페이", "온라인결제");
        put("국민행복", "기타");
        put("공과금", "할인");
        put("라운지키", "여행");
        put("도서", "문화/생활");
        put("자동차", "교통");
        put("국내외가맹점", "여행");
        put("병원/약국", "의료");
        put("뷰티/피트니스", "문화/생활");
        put("비즈니스", "문화/생활");
        put("금융", "온라인결제");
        put("APP", "기타");
        put("학원", "문화/생활");
        put("공과금/렌탈", "할인");
        put("카카오페이", "온라인결제");
        put("SKT", "통신");
        put("정비", "교통");
        put("하이패스", "교통");
        put("자동차/하이패스", "교통");
        put("애완동물", "문화/생활");
        put("LGU+", "통신");
        put("해외직구", "쇼핑");
        put("음원사이트", "문화/생활");
        put("면세점", "쇼핑");
        put("은행사", "온라인결제");
        put("패스트푸드", "푸드");
        put("아울렛", "쇼핑");
        put("SSM", "마트/마트/편의점");
        put("CJ ONE", "쇼핑");
        put("경기관람", "문화/생활");
        put("지역", "기타");
        put("PP", "여행");
        put("호텔", "여행");
        put("캐시백", "할인");
        put("항공마일리지", "여행");
        put("진에어", "여행");
        put("공연/전시", "문화/생활");
        put("보험", "문화/생활");
        put("렌터카", "교통");
        put("기차", "교통");
        put("화장품", "의료");
        put("병원", "의료");
        put("항공권", "여행");
        put("SPA브랜드", "문화/생활");
        put("피트니스", "문화/생활");
        put("렌탈", "문화/생활");
        put("인테리어", "문화/생활");
        put("혜택 프로모션", "할인");
        put("문화센터", "문화/생활");
        put("레저/스포츠", "문화/생활");
        put("리조트", "여행");
        put("고속버스", "교통");
        put("공항", "여행");
        put("선택형4", "선택형4");
        put("해피포인트", "할인");
        put("아이행복", "문화/생활");
        put("약국", "의료");
        put("학습지", "문화/생활");
        put("제주항공", "여행");
        put("OK캐쉬백", "할인");
        put("여행사", "여행");
        put("아이스크림", "푸드");
        put("헤어", "문화/생활");
        put("카드사", "온라인결제");
        put("연회비지원", "할인");
        put("저녁", "푸드");
        put("PAYCO", "온라인결제");
        put("공항라운지/PP", "여행");
        put("동물병원", "의료");
        put("하이브리드", "기타");
        put("저가항공", "여행");
        put("온라인 여행사", "여행");
        put("어린이집", "문화/생활");
        put("BC TOP", "온라인결제");
    }};
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

    private final Gson gson = new Gson();

    @Override
    public void DeleteMyCards(PrincipalDetails principalDetails, String cardid) {

        User user = userRepository.findById(principalDetails.getUserDto().getId())
            .orElseThrow(() -> new ErrorException(ErrorCode.USER_NOT_FOUND));

        PersonalCards personalCards = personalCardsRepository.findPersonalCardsByUserIdAndCardsIdAndUseYN(user.getId(), cardid, "Y")
            .orElseThrow(() -> new ErrorException(ErrorCode.PERSONAL_CARD_NOT_FOUND));

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

            String cardNo = jasyptUtil.decrypt(tmpRes.getCardNo());
            String maskedCardNumber = cardNo.replaceAll("(\\d{4}-)(\\d{4}-)(\\d{4}-)(\\d{4})", "$1****-****-$4");
            tmpRes.setCardNo(maskedCardNumber);

            Optional<Cards> cards = cardsRepository.findById(personalCards.getCardsId());
            cards.ifPresent(card -> {{
                tmpRes.setCardImage(card.getImageUrl());
            }});
            simplePersonalCardsRes.add(tmpRes);
        });
        return simplePersonalCardsRes;
    }

    @Override
    public void RegisterMyCards(PrincipalDetails principalDetails, RegisterCardsReq registerCardsReq) {

        User user = userRepository.findById(principalDetails.getUserDto().getId())
            .orElseThrow(() -> new ErrorException(ErrorCode.USER_NOT_FOUND));

        // XXX Codef Token 가져오기/ null -> 생성
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


        // XXX 토큰 유효 7일 -> 지나면 갱신
        if (codefToken.getUpdateTime().plusDays(7).isBefore(LocalDateTime.now())) {
            codefToken.setToken(codefApi.GetToken());
            codefRepository.save(codefToken);
        }
        
        // XXX 등록된 카드인지 확인
        List<PersonalCards> personalCardList = personalCardsRepository.findAllByUserIdAndCardCompanyAndUseYN(user.getId(), registerCardsReq.getCardCompany(), "Y");
        for (PersonalCards card : personalCardList) {
            if (jasyptUtil.decrypt(card.getCardNo()).equals(registerCardsReq.getCardNo())){
                throw new ErrorException(ErrorCode.DUPLICATE_CARD_NO);
            }
        }
        
        

        // XXX 유저에게 connectedId 존재 여부 확인
        if (user.getConnectedId() == null) {
            try {
                String newConnectedId = codefApi.GetConnectedToken(registerCardsReq, codefToken.getToken());
                user.setConnectedId(jasyptUtil.encrypt(newConnectedId));
                SaveUser(user); //  다른 Transactional에서 ConnectedId 저장 -> rollBack 안됨

            } catch (NoSuchPaddingException | IllegalBlockSizeException | NoSuchAlgorithmException |
                     InvalidKeySpecException | BadPaddingException | InvalidKeyException | IOException |
                     ParseException | InterruptedException ignore) {
            }
        }

        // XXX 등록한 은행 리스트 가져오기
        List<String> bankList = null;
        try {
            bankList =codefApi.GetAccountList(jasyptUtil.decrypt(user.getConnectedId()), codefToken.getToken());
        } catch (IOException | ParseException | InterruptedException ignore) {

        }
        // XXX 없으면 은행 등록
        if (!bankList.contains(registerCardsReq.getCardCompany())){
            try {
                String newConnectedId = codefApi.AddBankInConnectedId(registerCardsReq, user, codefToken.getToken());
                user.setConnectedId(jasyptUtil.encrypt(newConnectedId));
                SaveUser(user);

            } catch (NoSuchPaddingException | IllegalBlockSizeException | NoSuchAlgorithmException |
                     InvalidKeySpecException | BadPaddingException | InvalidKeyException | IOException |
                     ParseException | InterruptedException ignore) {}
        }



        // XXX 내가 등록한 카드 다 가지고 오기 >> 없으면 내 카드가 아닌 것이구나??
        String userCards;
        Boolean myCards = true;
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
        JSONArray cardsListArray = new JSONArray();

        try {
            if (usercardsJson.get("data") instanceof JSONArray) {
                // 'data'가 배열인 경우
                cardsListArray = usercardsJson.getJSONArray("data");

            } else if (usercardsJson.get("data") instanceof JSONObject) {
                // 'data'가 객체인 경우
                cardsListArray.put(usercardsJson);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        // mongoDB : 크롤링한 카드 이름과 비교하여 찾기
        String cardNameTarget = "Card"; // 임시 카드 이름
        for (Object o : cardsListArray) {

            Map<String, Object> o1 = gson.fromJson(o.toString(), Map.class);
            log.info(o1.toString());
            String maskedStr1 = null;
            // 카드 조회 1개면 Object N개 List<Object> 로 옴
            try{
                Map<String, String> data = (Map<String, String>)o1.get("data");
                maskedStr1 = data.get("resCardNo");
                cardNameTarget = data.get("resCardName");
                cardNameTarget = cardNameTarget.replaceAll("[`~!@#$%^&*()_|+\\-=?;:'\",.<>\\{\\}\\[\\]\\\\\\/ ]", "");
            }catch (NullPointerException ignore){
                maskedStr1 = (String)o1.get("resCardNo");
                cardNameTarget = (String)o1.get("resCardName");
                cardNameTarget = cardNameTarget.replaceAll("[`~!@#$%^&*()_|+\\-=?;:'\",.<>\\{\\}\\[\\]\\\\\\/ ]", "");
            }
            //
            String maskedStr2 = registerCardsReq.getCardNo().replace("-", "");
            int matchingChars = 0;
            for (int i = 0; i < maskedStr1.length(); i++) {
                if (maskedStr1.charAt(i) == maskedStr2.charAt(i)) {
                    matchingChars++;
                }
            }

            maskedStr1 = maskedStr1.replaceAll("\\*", "");
            if(maskedStr2.length() - (maskedStr2.length()-maskedStr1.length()) == matchingChars){
                // 일치 -> 내 카드를 찾음 >> 어떤 카드 이름인지 알 수있다
                myCards = false;
                break;
            }
        }
        if (myCards){
            throw new ErrorException(ErrorCode.NOT_MY_CARDS);
        }

        String cardsIdTarget = "0000";  // 임시 카드 타겟
        // MongoDB 카드 Id와  매칭 하기
        Optional<Cards> optionalCards = cardsRepository.findByImageNameRegex(cardNameTarget);
        if (optionalCards.isPresent()){
            cardNameTarget = optionalCards.get().getCardName();
            cardsIdTarget = optionalCards.get().getId();
        }


        // XXX 카드 저장 하기
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
        // 어제 날짜까지
        calendar.add(Calendar.DATE, -1); // 어제
        String endDay = dateFormat.format(calendar.getTime());

        calendar.add(Calendar.MONTH, -1); // 한 달을 빼서 지난달로 설정
        calendar.set(Calendar.DAY_OF_MONTH, 1); // 그 달의 첫 번째 날로 설정
        String startDay = dateFormat.format(calendar.getTime());

        // XXX 사용내역 가지고 오기 (저번달 1일 ~ 어제)
        try {
            String payListResult = codefApi.GetUseCardList(registerCardsReq, user, codefToken.getToken(),startDay,endDay);
            // 저장하러 가기
            cardHistoryService.saveCardHistories(payListResult, user, personalCards.getId());
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        // 분산 실행
        runNotebook();
    }

    @Override
    public PersonalCardsDetailRes GetPersonaLCardDetail(PrincipalDetails principalDetails, long cardId) {
        User user = userRepository.findById(principalDetails.getUserDto().getId())
            .orElseThrow(() -> new ErrorException(ErrorCode.USER_NOT_FOUND));

        PersonalCards personalCards = personalCardsRepository.findById(cardId)
            .orElseThrow(() -> new ErrorException(ErrorCode.PERSONAL_CARD_NOT_FOUND));
        Cards cards = cardsRepository.findById(personalCards.getCardsId())
            .orElseThrow(() -> new ErrorException(ErrorCode.CARDS_NOT_FOUND));

        CardInfo cardInfo = cardInfoRepository.findCardInfoByCardId(cards.getId())
            .orElseThrow(() -> new ErrorException(ErrorCode.CARDINFO_NOT_FOUND));

        LocalDate today = LocalDate.now();
        LocalDate firstDayOfMonth = today.withDayOfMonth(1); // 이번 달의 첫 번째 날짜
        LocalDate yesterday = today.minusDays(1); // 이번 달의 첫 번째 날짜
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");

        String startDate = firstDayOfMonth.format(formatter);
        String endDate = today.format(formatter);
        String yesterDay = yesterday.format(formatter);

        List<CardHistoryEntity> monthlyUsageDetails = cardHistoryRepository.findAllByDateRangeOrderedByDateAndTimeDesc((int)user.getId(), startDate, endDate);

        // date를 먼저 비교하고, date가 같으면 time으로 비교
        monthlyUsageDetails = monthlyUsageDetails.stream()
            .sorted(Comparator.comparing(CardHistoryEntity::getDate).thenComparingInt(CardHistoryEntity::getTime).reversed())
            .toList();

        int useMoney = 0;
        List<SimpleCardHistory> secondReturnValue = new ArrayList<>();
        for (CardHistoryEntity cardHistoryEntity : monthlyUsageDetails) {
            useMoney = useMoney + cardHistoryEntity.getAmount();

            if (cardHistoryEntity.getDate().equals(endDate) || cardHistoryEntity.getDate().equals(yesterDay)){
                secondReturnValue.add(statisticsMapper.ToSimpleCardHistory(cardHistoryEntity));
            }
        }
        String useValue = cardHistoryService.CalculateBenefit(cardInfo, monthlyUsageDetails);
        Type type = new TypeToken<Map<String, Integer>>(){}.getType();
        Map<String, Integer> useBenefit = gson.fromJson(useValue, type);

        return PersonalCardsDetailRes.builder()
            .cardImage(cards.getImageUrl())
            .cardName(cards.getCardName())
            .cardCompany(cards.getOrganization_id())
            .useMoneyMonth(useMoney)
            .todayUseHistory(secondReturnValue)
            .useBenefit(useBenefit)
            .build();

    }

    @Override
    public RecommendPersonalCardRes GetRecommendPersonalCard(PrincipalDetails principalDetails) {
        User user = userRepository.findById(principalDetails.getUserDto().getId())
            .orElseThrow(() -> new ErrorException(ErrorCode.USER_NOT_FOUND));

        // XXX 저번달 1일 ~~ 오늘 까지 결재 내역 가지고 오기
        LocalDate today = LocalDate.now();
        LocalDate firstDayOfMonth = today.minusMonths(1).withDayOfMonth(1);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");

        String startDate = firstDayOfMonth.format(formatter);
        String endDate = today.format(formatter);

        // XXX userId 기준  시작날짜 < x < 종료날짜   결재 내역 가지고 오기
        List<CardHistoryEntity> cardHistoryEntities = cardHistoryRepository.findAllByDateRangeOrderedByDateAndTimeDesc((int) user.getId(), startDate, endDate);
        if(cardHistoryEntities.isEmpty()){
            throw new ErrorException(ErrorCode.CARDINFO_NOT_FOUND);
        }

        Map<String, Integer> consumptionHistory = new HashMap<>();
        for (CardHistoryEntity cardHistory : cardHistoryEntities) {
            int useMoney = consumptionHistory.getOrDefault(cardHistory.getCategory(), 0);
            consumptionHistory.put(cardHistory.getCategory(), useMoney+cardHistory.getAmount());
        }
        // XXX 사용 금액 순 카테고리 정렬 reverse True
        List<Map.Entry<String, Integer>> sortedEntries = consumptionHistory.entrySet()
            .stream()
            .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder()))
            .collect(Collectors.toList());

        List<RecommendCard> returnValue = new ArrayList<>();

        for (int i = 0; i < 3; i++){
            String category;
            try {
                category = sortedEntries.get(i).getKey();
            }catch (IndexOutOfBoundsException ignore){
                continue;
            }
            List<CardInfo> cardInfos = cardsAggregation.GetCardsCategoList(category);

            RecommendCard topCategoryResult = RecommendCard.builder()
                .category(category)
                .total(sortedEntries.get(i).getValue())
                .build();



            List<SimpleCard> addBenefitCal = new ArrayList<>();
            for (CardInfo cardInfo : cardInfos) {
                // 카드 카테고리 별 할인 적용액 JSON
                String useValue = cardHistoryService.CalculateBenefit(cardInfo, cardHistoryEntities);
                Type type = new TypeToken<Map<String, Integer>>(){}.getType();
                Map<String, Integer> useBenefit = gson.fromJson(useValue, type); // Map으로 바꾸기

                int idx = cardInfo.getGroupCategory().indexOf(category);
                String key = cardInfo.getCategories().get(idx);
                Map<String, String> benefitContents;
                try{
                    benefitContents = (Map<String, String>) cardInfo.getContents().get(key).get(1);
                }catch (NullPointerException ignore){
                    continue;
                }
                String categoryBenefit = benefitContents.get("benefitSummary");
                Cards cards = cardsRepository.findById(cardInfo.getCardId())
                    .orElseThrow(() -> new ErrorException(ErrorCode.CARDS_NOT_FOUND));
                addBenefitCal.add(SimpleCard.builder()
                        .cardId(cardInfo.getCardId())
                        .cardImg(cards.getImageUrl())
                        .cardName(cards.getCardName())
                        .cardCompany(cards.getOrganization_id())
                        .cardContent(categoryBenefit)
                        .useMoney(useBenefit.get(category))
                    .build());

            }
            //  할인 받은 금액을 기준으로 내림차순으로 정렬
            addBenefitCal.sort(Comparator.comparingInt(SimpleCard::getUseMoney).reversed());
            topCategoryResult.setCard((addBenefitCal.subList(0, Math.min(addBenefitCal.size(), 3))));

            returnValue.add(topCategoryResult);

        }

        return RecommendPersonalCardRes.builder()
            .name(user.getNickname())
            .discount(returnValue)
            .build();



    }


    @Transactional
    public void SaveUser(User user){
        log.info("HERE USER ????? ? ? ? ?");
        userRepository.saveAndFlush(user);
    }

}
