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
import com.ssafy.pickachu.domain.user.entity.User;
import com.ssafy.pickachu.domain.user.repository.UserRepository;
import com.ssafy.pickachu.global.codef.CodefApi;
import com.ssafy.pickachu.global.exception.ErrorCode;
import com.ssafy.pickachu.global.exception.ErrorException;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


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
        // Codef Token 가져오기/생성
        CodefToken codefToken = codefRepository.findById(1)
            .orElseGet(() -> {
                log.info("START GET CODEF TOKEN");
                CodefToken token = CodefToken.builder()
                    .id(1)
                    .token(codefApi.GetToken())
                    .updateTime(LocalDateTime.now())
//                    .token(PUBLIC_KEY)
                    .build();
                return  token;
            });
        codefRepository.save(codefToken);
        em.flush(); // 강제 자징


        User user = userRepository.findById(principalDetails.getUserDto().getId())
            .orElseThrow(() -> new ErrorException(ErrorCode.USER_NOT_FOUND));
        log.info("userINFO : " + user.getId() + user.getNickname());




        log.info("codefToken : " + codefToken.getToken());
        // 시간 지났으면 갱신
//        if (codefToken.getUpdateTime().plusDays(7).isBefore(LocalDateTime.now())) {
//            codefToken.setToken(codefToken.getToken());
//            codefRepository.save(codefToken);
//        }

        // TODO codef 카드 등록 하기
        // XXX 유저에게 connectedId 존재 여부 확인
        log.info("CONNECTED after ID : " + user.getConnectedId());

        if (user.getConnectedId() == null) {
            log.info("connectedId is null go getF");
            // XXX ConnectedId 추가하기
            try {
                String newConnectedId = codefApi.GetConnectedToken(registerCardsReq, codefToken.getToken());
                user.setConnectedId(newConnectedId);
                log.info("new connectedId : " + user.getConnectedId());
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
                    user.setConnectedId(newConnectedId);
                    log.info("new connectedId add bank : " + user.getConnectedId());
                } catch (NoSuchPaddingException | IllegalBlockSizeException | NoSuchAlgorithmException |
                         InvalidKeySpecException | BadPaddingException | InvalidKeyException | IOException |
                         ParseException | InterruptedException ignore) {
                }
            }
        }

//        // TODO 사용내역 가지고 오기
//        try {
//            codefApi.GetUseCardList(registerCardsReq, user, codefToken.getToken());
//        } catch (IOException e) {
//            throw new RuntimeException(e);
//        } catch (ParseException e) {
//            throw new RuntimeException(e);
//        } catch (InterruptedException e) {
//            throw new RuntimeException(e);
//        }
// 카드 저장.. 이거. 안될것 같은데
        PersonalCards personalCards = PersonalCards.builder()
            .cardCompany(registerCardsReq.getCardCompany())
            .cardNo(registerCardsReq.getCardNo())
            .cardCompanyId(registerCardsReq.getCardCompanyId())
            .cardCompanyPw(registerCardsReq.getCardCompanyPw())
            .cardsId("2346")
            .build();
        personalCardsRepository.save(personalCards);
        userRepository.save(user);
    }
}
