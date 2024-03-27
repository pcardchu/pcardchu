package com.ssafy.pickachu.domain.statistics.serviceImpl;

import com.ssafy.pickachu.domain.statistics.dto.CalendarAmount;
import com.ssafy.pickachu.domain.statistics.dto.Category;
import com.ssafy.pickachu.domain.statistics.dto.MyConsumption;
import com.ssafy.pickachu.domain.statistics.dto.Top3Category;
import com.ssafy.pickachu.domain.statistics.entity.CardHistoryEntity;
import com.ssafy.pickachu.domain.statistics.entity.MyConsumptionEntity;
import com.ssafy.pickachu.domain.statistics.repository.CardHistoryEntityRepository;
import com.ssafy.pickachu.domain.statistics.repository.MyConsumptionEntityRepository;
import com.ssafy.pickachu.domain.statistics.response.MyConsumptionResponse;
import com.ssafy.pickachu.domain.statistics.response.PeakTimeAgeResponse;
import com.ssafy.pickachu.domain.statistics.response.Top3CategoryResponse;
import com.ssafy.pickachu.domain.statistics.entity.PeakTimeAgeEntity;
import com.ssafy.pickachu.domain.statistics.entity.Top3CategoryEntity;
import com.ssafy.pickachu.domain.statistics.repository.PeakTimeAgeEntityRepository;
import com.ssafy.pickachu.domain.statistics.repository.Top3CategoryEntityRepository;
import com.ssafy.pickachu.global.util.CommonUtil;
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
    private final MyConsumptionEntityRepository myConsumptionEntityRepository;
    private final CardHistoryEntityRepository cardHistoryEntityRepository;
    private final IndustryCode code = IndustryCode.getInstance();
    private final Calendar calendar = Calendar.getInstance();
    CommonUtil commonUtil = new CommonUtil();

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

    @Override
    public ResponseEntity<MyConsumptionResponse> getMyConsumption() {

        List<MyConsumptionEntity> datas = myConsumptionEntityRepository.findMyConsumptionById(1);
        Collections.sort(datas);

        String thisMonth = commonUtil.getCurrentYearAndMonth();
        String lastMonth = commonUtil.getLastYearAndMonth();

        int currentTotalAmount = 0;
        int lastTotalAmount = 0;
        List<Category> mainConsumption = new ArrayList<>();
        for(MyConsumptionEntity data : datas){
            if(data.getDate().equals(thisMonth)){
                currentTotalAmount += data.getTotalAmount();
            }else if(data.getDate().equals(lastMonth)){
                lastTotalAmount += data.getTotalAmount();
                mainConsumption.add(new Category(data.getCategory(), data.getTotalAmount()));
            }
        }


        List<CalendarAmount> calendarAmountList = new ArrayList<>();
        List<CardHistoryEntity> historyDatas =  cardHistoryEntityRepository.findMyCardHistoryById(1);

        HashMap<String, Integer> todaySum = new HashMap<>();
        for(CardHistoryEntity historyData : historyDatas){
            // sum 해줘야함.....
            int sum = todaySum.getOrDefault(historyData.getDate(), 0);
            todaySum.put(historyData.getDate(), sum+historyData.getAmount());
        }

        for(String date : todaySum.keySet()){
            calendarAmountList.add(new CalendarAmount(date, todaySum.get(date)));
        }

        // 수정 예정
        MyConsumption data = new MyConsumption();
        data.setUserName("옹곤");
        data.setTotalAmount(lastTotalAmount);
        data.setAmountGap(currentTotalAmount-lastTotalAmount);
        data.setMainConsumption(mainConsumption);
        data.setThisMonthAmount(currentTotalAmount);
        data.setCalendar(calendarAmountList);

        MyConsumptionResponse response = MyConsumptionResponse
                .createMyConsumptionResponse(
                        HttpStatus.OK.value(), "Success", data
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
