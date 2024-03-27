package com.ssafy.pickachu.global.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class CommonUtil {
    public String getCurrentYearAndMonth(){
        // 현재 날짜 가져오기
        LocalDate now = LocalDate.now();

        // DateTimeFormatter를 사용해 원하는 형태로 날짜 포맷 정의
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMM");

        // 현재 연월을 "YYYYMM" 형태로 포맷
        return now.format(formatter);

    }

    public String getLastYearAndMonth(){
        // 현재 날짜 가져오기
        LocalDate now = LocalDate.now();
        now = now.minusMonths(1);
        // DateTimeFormatter를 사용해 원하는 형태로 날짜 포맷 정의
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMM");

        // 현재 연월을 "YYYYMM" 형태로 포맷
        return now.format(formatter);
    }

}
