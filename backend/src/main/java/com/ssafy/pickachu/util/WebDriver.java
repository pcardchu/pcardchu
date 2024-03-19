package com.ssafy.pickachu.util;


import lombok.extern.slf4j.Slf4j;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Slf4j
@Configuration
public class WebDriver {

    private org.openqa.selenium.WebDriver webDriver;

    @Bean
    public org.openqa.selenium.WebDriver webDriver() {
        if (webDriver == null) {
            log.info("WebDriver Create");
            System.setProperty("webdriver.chrome.driver", "src\\main\\resources\\chromedriver.exe");
            ChromeOptions options = new ChromeOptions();
            options.addArguments("--headless"); // Headless 모드 활성화
            webDriver = new ChromeDriver(options);
        }
        return webDriver;
    }

    public org.openqa.selenium.WebDriver getWebDriver(){
        return webDriver;
    }

    public org.openqa.selenium.WebDriver refreshWebDriver() {
        if (webDriver != null) {
            webDriver.quit();
            log.info("Existing WebDriver instance terminated");
        }
        // 새로운 인스턴스 생성
        System.setProperty("webdriver.chrome.driver", "src\\main\\resources\\chromedriver.exe");
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless");
        webDriver = new ChromeDriver(options);
        log.info("Created new WebDriver instance");
        return webDriver;
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