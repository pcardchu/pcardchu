package com.ssafy.pickachu.crawling.service;


import com.ssafy.pickachu.cards.entity.CardInfo;
import com.ssafy.pickachu.cards.entity.Cards;
import com.ssafy.pickachu.cards.repository.CardInfoRepository;
import com.ssafy.pickachu.cards.repository.CardsRepository;
import com.ssafy.pickachu.util.WebDriverChrome;
import com.ssafy.pickachu.crawling.dto.BenefitCalc;
import com.ssafy.pickachu.util.ImageUploader;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.openqa.selenium.*;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Slf4j
@RequiredArgsConstructor
@Configuration
@Transactional(readOnly = false)
@Service
public class CrawlingServiceImpl implements CrawlingService{


    @Value("${crawling.cards.regist}")
    private String REGIST_CARD;

    @Value("${crawling.cards.cond}")
    private String COND;
    @Value("${crawling.cards.url}")
    private String CRAWLING_URL;

    private final WebDriverChrome webDriver;
    private final ImageUploader imageUploader;
    private final CardsRepository cardsRepository;
    private final CardInfoRepository cardInfoRepository;

    final static Map<String, String> PAY_TYPES = new LinkedHashMap<String, String>() {{
        put("%", "(\\d+)(?=\\%)");                                                            // ex 10% -> 10
        put("이상", "\\b(\\d+(?:,\\d+|[가-힣]))원 이상.*?(\\d+(?:,\\d+|[가-힣]|))원\\s.*?할인");  // ex  10,000원 이상 결제 시 5천원 결제일할인 -> 10,000 5천
        put("원", "(\\d+(?:,\\d+|[가-힣]|))원");                                               // oo원  or oo만원 or oo,ooo원
    }};
    final static Map<String, String> WON_UNIT = new LinkedHashMap<String, String>() {{
        put("십만", "00000");
        put("만", "0000");
        put("천", "000");
    }};


    @Override
    public void CrawlingCards(String cardCompanyId) {
        log.info("Crawling Start");

        org.openqa.selenium.WebDriver driver = webDriver.getWebDriver();


        // XXX 카드사 보유 카드 detail URL 주소 가져오기 : cardsList

        // 여기는 진짜 카드사 모든 카드 가져오는 코드
        List<String> cardsList = new ArrayList<>();
        String target = CRAWLING_URL + cardCompanyId;
        driver.get(target);
        WebElement moreCards = driver.findElement(By.className("lst_more"));
        while(!moreCards.getAttribute("style").equals("display: none;")){
            try{
                moreCards = driver.findElement(By.className("lst_more"));
                moreCards.click();
                log.info(moreCards.getAttribute("style"));
//                Thread.sleep(150);
            } catch (ElementNotInteractableException | NoSuchElementException e) {  }
        }

        WebElement cardsLst = driver.findElements(By.className("lst")).get(1);
        List<WebElement> elements = cardsLst.findElements(By.cssSelector("a.b_view"));

        for (WebElement element : elements) {
            cardsList.add(element.getAttribute("href"));
        }


        int ii = 1;
        // driver 사용 횟수 카운트 : 세션유지 -> for문 10번마다 driver 갱신
        int driverUseCount = 0;
        for (String cardUrl : cardsList){

            // XXX 카드 고유값 가지고 오기 : CardId
            String cardId = cardUrl.substring(cardUrl.lastIndexOf('/') + 1);
            log.info(ii++ + " : " +cardId);
            // 저장한 카드 패스
            if(cardsRepository.findById(cardId).isPresent()){
                log.info("EXIST CARD ");
                continue;
            }

            // 여기에 각 URL을 이용하여 card html 가져오기
            driver.get(cardUrl);
            try{
                Thread.sleep(1000); // 로딩 시간 벌기
            }catch(InterruptedException e){

            }

            WebElement cardInfoTags = driver.findElement(By.xpath("//*[@id=\"q-app\"]/section/div[1]/section/div/article[1]/div/div/div[2]"));
            WebElement cardInfoTag = cardInfoTags.findElement(By.className("tit"));
            WebElement cardNameTag = cardInfoTag.findElement(By.tagName("strong"));
            WebElement cardCompanyTag = cardInfoTag.findElement(By.tagName("p"));

            // XXX 카드 [이름, 회사] 가지고 오기 : cardName, cardCompany
            String cardName = cardNameTag.getText();
            String cardCompany = cardCompanyTag.getText();

            // XXX 연회비 안내 가지고 오기 : annualFeeInfo
            List<String> annualFeeInfo = new ArrayList<>();
            WebElement bnf2Element = driver.findElement(By.className("bnf2"));
            List<WebElement> dlTags = bnf2Element.findElements(By.tagName("dl"));

            annualFeeInfo.add(dlTags.get(1).findElement(By.tagName("dt")).getText());
            annualFeeInfo.add(dlTags.get(1).findElement(By.tagName("dd")).getText());
            annualFeeInfo.add(dlTags.get(2).findElement(By.tagName("span")).getText());
            WebElement spanTag = null;
            try {
                spanTag = bnf2Element.findElement(By.xpath("./span"));
                annualFeeInfo.add(spanTag.getText());
            } catch (NoSuchElementException e) {
            }

            //XXX 카드 이미지 저장 코드 : imgPath
            WebElement img = driver.findElement(By.cssSelector("img[data-v-e76ea864]"));
            String imgUrl = img.getAttribute("src");
            String extension = imgUrl.substring(imgUrl.lastIndexOf('.') + 1);
            String saveName = cardCompany+"_"+cardName.replaceAll("[\\\\/:*?\"<>| ]", "")+"_"+cardId;
            String imgPath = imageUploader.ImgaeUpload(imgUrl, saveName, extension);

            // XXX 카드 혜택 요소 클릭하기 (자세히 보기)-> Accordion
            elements = driver.findElements(By.cssSelector("dl[data-v-e76ea864][data-v-35734774]"));
            for (int i = 0; i < elements.size(); i++) {
                try {
                    WebElement element = elements.get(i);
                    element.click();
                }
                catch (Exception e){
                }
            }

            // XXX 카드 혜택 + 할인 방법 저장 리스트 : content
            Map<String, List<Object>> content = new HashMap<>();
            // XXX 카드 카테고리 목록 리스트 : categories
            ArrayList<String> categories = new ArrayList<>();
            // 선택 혜택 구분 변수
            int choiceNum = 1;
            // content, categories 만들러 가기
            for (WebElement dlElement : elements) {

                WebElement dtElement;   // 카테고리 & 한줄요약
                WebElement pElement;    // 카테고리
                WebElement iElement;    // 한줄요약
                WebElement ddElement;   // 혜택 디테일
                try { // 이부분
                    dtElement = dlElement.findElement(By.tagName("dt"));
                    pElement = dtElement.findElement(By.tagName("p"));
                    iElement = dtElement.findElement(By.tagName("i"));
                    ddElement = dlElement.findElement(By.tagName("dd"));
                } catch (NoSuchElementException | StaleElementReferenceException e) {
                    // 혜택이 없는 태그 -> 넘어가라
                    continue;
                }
                // XXX 혜택 카테고리 : category
                String category = pElement.getText();
                category = (category.equals("선택형"))?category + choiceNum++:category;
                categories.add(category);

                // XXX 혜택 한 줄 요약 : benefitSummary
                String benefitSummary = iElement.getText();

                // XXX 혜택 디테일 : categoriesBenefitContents
                ArrayList<String> categoriesBenefitContents = new ArrayList();
                List<WebElement> pElementsList = ddElement.findElements(By.tagName("p"));
                for (WebElement element : pElementsList) {
                    try{
                        String eText = element.getText().trim();
                        if (!element.getText().equals("")){
                            categoriesBenefitContents.add(eText);
                        }
                    }catch(StaleElementReferenceException e){
                    }
                }

                // XXX 할인종류 ex> 10% > % : payType
                String payType = "";
                Set<String> allPayTypeKeys = PAY_TYPES.keySet();
                for (String key : allPayTypeKeys) {
                    if(benefitSummary.contains(key)){
                        payType = key;
                        break;
                    }
                }

                // XXX 할인액 ex> 10% > 10 : benefitAmount
                // 1000원 이상 100원 할인 >  1000, 100
                ArrayList<Long> benefitAmount = new ArrayList();

                if(!payType.equals("")) {
                    Pattern pattern = Pattern.compile(PAY_TYPES.get(payType));
                    Matcher matcher = pattern.matcher(benefitSummary);
                    if (matcher.find()) {
                        for (int i = 1; i <= matcher.groupCount(); i++) {

                            String findAmount = matcher.group(i).replaceAll("\\s", "");
                            // 돈 단위가 한글일 때 숫자로 바꾸기
                            boolean flag = true;
                            for (String won : WON_UNIT.keySet()) {
                                if (findAmount.contains(won)) {
                                    findAmount = findAmount.replace(won, WON_UNIT.get(won));
                                    flag = false;
                                }
                            }
                            // 돈 단위가 , 일 때
                            if (flag && findAmount.contains(",")) {
                                findAmount = findAmount.replace(",", "");
                            }
                            benefitAmount.add(Long.valueOf(findAmount));
                        }
                    }
                }
                // XXX 할인 방법 만들기 : benefitCalc
                BenefitCalc benefitCalc = BenefitCalc.builder()
                        .benefitSummary(benefitSummary)
                        .category(category)
                        .payType(payType)
                        .build();
                if(benefitAmount.size() != 1 && !benefitAmount.isEmpty()){
                    benefitCalc.setUnit(benefitAmount.get(0));
                    benefitCalc.setDiscount(benefitAmount.get(1));
                }else if (benefitAmount.size() == 1){
                    benefitCalc.setDiscount(benefitAmount.get(0));
                }
                // XXX content에 혜택(카드혜택, 할인방법) 넣기
                if(!categoriesBenefitContents.isEmpty() && !benefitAmount.isEmpty()){
                    ArrayList<Object> benefitPackage = new ArrayList<>(){{
                        add(categoriesBenefitContents);
                        add(benefitCalc);}};
//                    content.add(benefitPackage);

                    content.put(category, benefitPackage);
                }
            } // for 문 끝 content 완성

            // XXX 카드사 바로가기 URL : makeCardUrl
            String url = REGIST_CARD + cardId;
            String makeCardUrl = "";
            try {
                driver.get(url);
                // 카드 회사로 redirect 될 떄 까지 반복
                while (url.contains(COND) && url.equals(driver.getCurrentUrl())){
                    try{
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        throw new RuntimeException(e);
                    }
                }
                makeCardUrl = driver.getCurrentUrl();
            } catch (UnhandledAlertException e) {
                try {
                    Alert alert = driver.switchTo().alert();
                    alert.dismiss(); // 팝업창을 닫는 코드
                } catch (NoAlertPresentException ex) {
                    // 이미 alert이 사라진 경우 처리할 내용
                }
            }

            // XXX Cards 저장 : cards
            Cards cards = Cards.builder()
                    .id(cardId)
                    .cardName(cardName)
                    .organization_id(cardCompany)
                    .imageName(saveName + extension)
                    .imageUrl(imgPath)
                    .registrationUrl(makeCardUrl)
                    .build();
            cardsRepository.save(cards);

            // XXX CardInfo 저장 : cardInfo
            CardInfo cardInfo = CardInfo.builder()
                    .cardId(cardId)
                    .categories(categories)
                    .annualFeeInfo(annualFeeInfo)
                    .contents(content)
                    .build();
            cardInfoRepository.save(cardInfo);

            // 10번 넘어갈 떄 마다 driver 갱신
            driverUseCount++;
            if(driverUseCount == 10){
                driverUseCount=0;
                webDriver.quitWebDriver();
                driver = webDriver.refreshWebDriver();
            }
        }
        log.info("Crawling END");
    }
}
