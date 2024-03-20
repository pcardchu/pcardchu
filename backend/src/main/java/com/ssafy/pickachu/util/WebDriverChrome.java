package com.ssafy.pickachu.util;


import lombok.extern.slf4j.Slf4j;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.springframework.context.annotation.Configuration;

@Slf4j
@Configuration
public class WebDriverChrome {

    private WebDriver webDriver;

    public WebDriverChrome() {
        if (this.webDriver == null) {
            log.info("WebDriver Create");
            System.setProperty("webdriver.chrome.driver", "src\\main\\resources\\chromedriver.exe");
            ChromeOptions options = new ChromeOptions();
            options.addArguments("--headless"); // Headless 모드 활성화
            this.webDriver = new ChromeDriver(options);
        }
    }


    public org.openqa.selenium.WebDriver getWebDriver(){
        return this.webDriver;
    }

    public org.openqa.selenium.WebDriver refreshWebDriver() {
        if (this.webDriver != null) {
            this.webDriver.quit();
            log.info("Existing WebDriver instance terminated");
        }
        // 새로운 인스턴스 생성
        System.setProperty("webdriver.chrome.driver", "src\\main\\resources\\chromedriver.exe");
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless");
        this.webDriver = new ChromeDriver(options);
        log.info("Created new WebDriver instance");
        return this.webDriver;
    }

    public void quitWebDriver() {
        if (webDriver != null) {
            webDriver.quit();
        }
        webDriver = null;
        if (webDriver == null){
            log.info("webDriver DELETE SUCCESS");
        }else{
            log.info("webDriver DELETE FAIL....");

        }
    }
}