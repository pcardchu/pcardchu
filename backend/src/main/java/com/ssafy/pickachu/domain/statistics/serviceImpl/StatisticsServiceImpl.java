package com.ssafy.pickachu.domain.statistics.serviceImpl;

import com.ssafy.pickachu.domain.auth.PrincipalDetails;
import com.ssafy.pickachu.domain.statistics.dto.*;
import com.ssafy.pickachu.domain.statistics.entity.*;
import com.ssafy.pickachu.domain.statistics.exception.UserInfoUnavailableException;
import com.ssafy.pickachu.domain.statistics.repository.*;
import com.ssafy.pickachu.domain.statistics.response.AverageComparisonRes;
import com.ssafy.pickachu.domain.statistics.response.MyConsumptionRes;
import com.ssafy.pickachu.domain.statistics.response.PeakTimeAgeRes;
import com.ssafy.pickachu.domain.statistics.response.Top3CategoryRes;
import com.ssafy.pickachu.domain.user.entity.User;
import com.ssafy.pickachu.domain.user.repository.UserRepository;
import com.ssafy.pickachu.global.util.CommonUtil;
import com.ssafy.pickachu.global.util.IndustryCode;
import com.ssafy.pickachu.domain.statistics.service.StatisticsService;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.checkerframework.checker.units.qual.A;
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
    private final AverageAmountEntityRepository averageAmountEntityRepository;
    private final UserRepository userRepository;
    private final IndustryCode code = IndustryCode.getInstance();
    private final Calendar calendar = Calendar.getInstance();
    CommonUtil commonUtil = new CommonUtil();

    @Override
    public ResponseEntity<Top3CategoryRes> getTop3Categories() {
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

        Top3CategoryRes response = Top3CategoryRes
                .createTop3CategoryResponse(
                        HttpStatus.OK.value(), "Success", values
                );

        return ResponseEntity.ok(response);

    }

    @Override
    public ResponseEntity<PeakTimeAgeRes> getPeakTimeAge() {
        List<PeakTimeAgeEntity> datas = peakTimeAgeEntityRepository.findAll();
        int currentTime = calendar.get(Calendar.HOUR_OF_DAY);

        String age = "";
        for(PeakTimeAgeEntity data : datas){
            if(data.getTime() == currentTime){
                age = data.getAge();
                break;
            }
        }

        PeakTimeAgeRes response = PeakTimeAgeRes
                .createPeakTimeAgeResponse(
                        HttpStatus.OK.value(), "Success", age
                );

        // 지울코드
        // 분석 배치 실행
        ProcessBuilder pb = new ProcessBuilder("/home/ubuntu/myconsumption_batch.sh");
        try {
            Process process = pb.start();
        }catch (Exception e){
            e.printStackTrace();
        }

        return ResponseEntity.ok(response);
    }

    @Override
    public ResponseEntity<MyConsumptionRes> getMyConsumption(PrincipalDetails principalDetails) {

        Long userid = principalDetails.getUserDto().getId();
        Optional<User> user = userRepository.findById(userid);

        List<MyConsumptionEntity> datas = myConsumptionEntityRepository.findMyConsumptionById(Math.toIntExact(userid));
        Collections.sort(datas);

        String thisMonth = commonUtil.getCurrentYearAndMonth();
        String lastMonth = commonUtil.getLastYearAndMonth();

        int currentTotalAmount = 0;
        int lastTotalAmount = 0;
        List<Category> mainConsumption = new ArrayList<>();
        System.out.println("month:::: "+thisMonth+" "+datas.get(0).getDate());
        for(MyConsumptionEntity data : datas){
            if(data.getDate().equals(thisMonth)){
                currentTotalAmount += data.getTotalAmount();
            }else if(data.getDate().equals(lastMonth)){
                lastTotalAmount += data.getTotalAmount();
                mainConsumption.add(new Category(data.getCategory(), data.getTotalAmount()));
            }
        }


        List<CalendarAmount> calendarAmountList = new ArrayList<>();
        List<CardHistoryEntity> historyDatas =  cardHistoryEntityRepository.findMyCardHistoryById(Math.toIntExact(userid));

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
        data.setUserName(user.get().getNickname());
        data.setTotalAmount(lastTotalAmount);
        data.setAmountGap(currentTotalAmount-lastTotalAmount);
        data.setMainConsumption(mainConsumption);
        data.setThisMonthAmount(currentTotalAmount);
        data.setCalendar(calendarAmountList);

        MyConsumptionRes response = MyConsumptionRes
                .createMyConsumptionResponse(
                        HttpStatus.OK.value(), "Success", data
                );

        return ResponseEntity.ok(response);
    }


    @Override
    public ResponseEntity<AverageComparisonRes> getAverageComparison(PrincipalDetails principalDetails) {

        Long userid = principalDetails.getUserDto().getId();
        Optional<User> user = userRepository.findById(userid);

        Date userBirth = user.get().getBirth();
        String userGender = user.get().getGender();

        if(userBirth == null || userGender == null) throw new UserInfoUnavailableException("성별 또는 나이가 입력되지 않아 통계 정보를 제공할 수 없습니다.");
        String userAgeGroup = commonUtil.calculateAge(userBirth);


        List<MyConsumptionEntity> historyDatas = myConsumptionEntityRepository.findMyConsumptionById(1);
        int totalAmount = 0;
        String lastMonth = commonUtil.getLastYearAndMonth();
        for(MyConsumptionEntity history : historyDatas){
            if(history.getDate().equals(lastMonth)) totalAmount += history.getTotalAmount();
        }

        totalAmount = totalAmount/historyDatas.size();

        int average = 0;
        List<AverageAmountEntity> totalDatas = averageAmountEntityRepository.findAll();
        for(AverageAmountEntity total : totalDatas){
            if(total.getAge().equals(userAgeGroup) && total.getGender().equals(userGender)){
                average = total.getAverage();
                break;
            }
        }

        int percent = (int)(((double)(totalAmount - average) / average) * 100);

        int lastMonthNumber = Integer.parseInt(lastMonth.substring(4));

        AverageGap data = new AverageGap(userAgeGroup, userGender, lastMonthNumber, percent);
        AverageComparisonRes response = AverageComparisonRes.createPeakTimeAgeResponse(
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
