package com.ssafy.pickachu.domain.statistics.serviceImpl;

import com.google.gson.Gson;
import com.ssafy.pickachu.domain.statistics.dto.CardHistory;
import com.ssafy.pickachu.domain.statistics.dto.Top3Category;
import com.ssafy.pickachu.domain.statistics.entity.CardHistoryEntity;
import com.ssafy.pickachu.domain.statistics.entity.PeakTimeAgeEntity;
import com.ssafy.pickachu.domain.statistics.entity.Top3CategoryEntity;
import com.ssafy.pickachu.domain.statistics.repository.CardHistoryEntityRepository;
import com.ssafy.pickachu.domain.statistics.repository.PeakTimeAgeEntityRepository;
import com.ssafy.pickachu.domain.statistics.repository.Top3CategoryEntityRepository;
import com.ssafy.pickachu.domain.statistics.response.PeakTimeAgeResponse;
import com.ssafy.pickachu.domain.statistics.response.Top3CategoryResponse;
import com.ssafy.pickachu.domain.statistics.service.CardHistoryService;
import com.ssafy.pickachu.domain.statistics.service.StatisticsService;
import com.ssafy.pickachu.global.util.IndustryCode;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

@Service
@RequiredArgsConstructor
public class CardHistoryServiceImpl implements CardHistoryService {

    private final CardHistoryEntityRepository repository;
    Gson gson = new Gson();
    @Override
    public String saveCardHistories() {
        /**
         * 추후 codefapi와 user table에서 정보를 가져와서 저장하는 것으로 바꿀 예정
         * 임시 데이터로 진행
         * */
        String filePath = "C:\\Users\\SSAFY\\Downloads\\history.txt";

        try {
            // JSON 파일로부터 읽기
            // 파일의 전체 내용을 문자열로 읽어옴
            String content = new String(Files.readAllBytes(Paths.get(filePath)));

            // 문자열 내용을 JSONArray 객체로 변환
            JSONArray jsonArray = new JSONArray(content);

            // JSONArray 내용 처리 예시
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonObject = (JSONObject) jsonArray.get(i);

                CardHistoryEntity history = gson.fromJson(String.valueOf(jsonObject), CardHistoryEntity.class);
                history.setUserid(1);
                history.setId(UUID.randomUUID());
                history.setGender("남성");
                history.setAge("20대");
                history.setCardId(1);
                repository.save(history);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return "Success";

    }


}