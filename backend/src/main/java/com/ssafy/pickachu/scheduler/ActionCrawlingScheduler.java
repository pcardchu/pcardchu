package com.ssafy.pickachu.scheduler;

import com.ssafy.pickachu.crawling.service.CrawlingService;
import org.springframework.scheduling.annotation.Scheduled;

public class ActionCrawlingScheduler {

    private static CrawlingService crawlingService;



    @Scheduled(fixedRate = 1000*60*60*24) // 하루 주기 크롤링
    public void auctionClosing() {
        crawlingService.CrawlingCards();
    }


}
