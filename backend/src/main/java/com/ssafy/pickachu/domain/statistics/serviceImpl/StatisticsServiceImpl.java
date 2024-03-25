package com.ssafy.pickachu.domain.statistics.serviceImpl;

import com.ssafy.pickachu.domain.statistics.dto.Top3Category;
import com.ssafy.pickachu.domain.statistics.response.PeakTimeAgeResponse;
import com.ssafy.pickachu.domain.statistics.response.Top3CategoryResponse;
import com.ssafy.pickachu.domain.statistics.entity.PeakTimeAgeEntity;
import com.ssafy.pickachu.domain.statistics.entity.Top3CategoryEntity;
import com.ssafy.pickachu.domain.statistics.repository.PeakTimeAgeEntityRepository;
import com.ssafy.pickachu.domain.statistics.repository.Top3CategoryEntityRepository;
import com.ssafy.pickachu.global.util.IndustryCode;
import com.ssafy.pickachu.domain.statistics.service.StatisticsService;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class StatisticsServiceImpl implements StatisticsService {
    private final Top3CategoryEntityRepository top3CategoryEntityRepository;
    private final PeakTimeAgeEntityRepository peakTimeAgeEntityRepository;
    private final IndustryCode code = IndustryCode.getInstance();
    private final Calendar calendar = Calendar.getInstance();

    @Override
    public ResponseEntity<Top3CategoryResponse> getTop3Categories() {
        List<Top3CategoryEntity> top3categories =  top3CategoryEntityRepository.findAll();
        Collections.sort(top3categories);

        HashMap<CategoryKey, Top3Category> hm = new HashMap<>();
        for(Top3CategoryEntity entity : top3categories){
            CategoryKey categoryKey = new CategoryKey(entity.getAge(), entity.getGender());

            int categoryCode = Integer.parseInt(entity.getCategory());
            if(hm.get(categoryKey) == null){
                Top3Category t3c = new Top3Category(categoryKey.age, categoryKey.gender);
                t3c.getCategoryList().add(code.industryCodeHashMap.getOrDefault(categoryCode, "기타"));
                hm.put(categoryKey, t3c);
            }else{
                Top3Category t3c =  hm.get(categoryKey);
                t3c.getCategoryList().add(code.industryCodeHashMap.getOrDefault(categoryCode, "기타"));
                hm.put(categoryKey, t3c);
            }

        }

        List<Top3Category> values = hm.values().stream().toList();

        Top3CategoryResponse response = Top3CategoryResponse
                .createTop3CategoryResponse(
                        HttpStatus.OK.value(), "Success", values
                );

        return ResponseEntity.ok(response);

    }

    @Override
    public ResponseEntity<PeakTimeAgeResponse> getPeakTimeAge() {
        List<PeakTimeAgeEntity> datas = peakTimeAgeEntityRepository.findAll();
        int currentTime = calendar.get(Calendar.HOUR_OF_DAY);

        String age = "";
        for(PeakTimeAgeEntity data : datas){
            if(data.getTime() == currentTime){
                age = data.getAge();
                break;
            }
        }

        PeakTimeAgeResponse response = PeakTimeAgeResponse
                .createPeakTimeAgeResponse(
                        HttpStatus.OK.value(), "Success", age
                );
        return ResponseEntity.ok(response);
    }

    @Data
    static class CategoryKey{
        String age; String gender;

        public CategoryKey(String age, String gender) {
            this.age = age; this.gender = gender;
        }
    }
}
