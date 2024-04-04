// package com.ssafy.pickachu.scheduler;

// import com.ssafy.pickachu.crawling.service.CrawlingService;
// import org.springframework.scheduling.annotation.Scheduled;

// import java.util.HashMap;
// import java.util.Map;

// public class ActionCrawlingScheduler {

//     private final CrawlingService crawlingService;

//     private int cardNum = 0;
//     private static Map<Integer, String> CARD_COMPANY_CODE = new HashMap<>(){{
//        put(0, "32");
//        put(1, "1");
//        put(2, "2");
//        put(3, "3");
//        put(4, "4");
//        put(5, "5");
//        put(6, "7");
//        put(7, "8");
//        put(8, "9");
//        put(9, "10");
//     }};
//     @Scheduled(fixedRate = 1000*60*60*24) // 하루 주기 카드사 하나 씩 크롤링
//     public void auctionClosing() {
//         crawlingService.CrawlingCards(CARD_COMPANY_CODE.get(cardNum++));
//     }


// }
