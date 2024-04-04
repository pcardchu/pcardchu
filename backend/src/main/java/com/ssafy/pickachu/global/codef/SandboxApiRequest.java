package com.ssafy.pickachu.global.codef;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 *  API 요청 템플릿 클래스
 */

@Slf4j
public class SandboxApiRequest {

    private static ObjectMapper mapper = new ObjectMapper();

    public static String reqeust(String urlPath, HashMap<String, Object> bodyMap, String ACCESS_TOKEN) throws IOException, InterruptedException, ParseException {
        // 리소스서버 접근을 위한 액세스토큰 설정(기존에 발급 받은 토큰이 있다면 유효기간 만료까지 재사용)
        String accessToken = ACCESS_TOKEN;

        // POST요청을 위한 리퀘스트바디 생성(UTF-8 인코딩)
        String bodyString = mapper.writeValueAsString(bodyMap);
        bodyString = URLEncoder.encode(bodyString, "UTF-8");

        // API 요청
        JSONObject json = (JSONObject)HttpRequest.post(urlPath, accessToken, bodyString);

        String code = (String) ((Map<String, Object>)json.get("result")).get("code");
        if(code.equals("CF-00000") && urlPath.equals(CommonConstant.TEST_DOMAIN+CommonConstant.KR_CD_P_002)){
            JSONArray payList = (JSONArray) json.get("data");
            String payResult = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(payList);
            return payResult;
        }
        // ==== API 요청 결과 확인
        String result = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(json);


        // 액세스 토큰 유효기간 만료시
        if("invalid_token".equals(json.get("error"))) {
            // "====    유효하지 않은 토큰인 경우 토큰 재발급 요청
            // 토큰 재발급 요청 수행
            accessToken = RequestToken.getToken(CommonConstant.SANDBOX_CLIENT_ID, CommonConstant.SANDBOX_SECERET_KEY);
            CommonConstant.ACCESS_TOKEN = accessToken;	// 재사용을 위한 발급받은 액세스 토큰 저장

            // API 재요청
            json = (JSONObject)HttpRequest.post(urlPath, accessToken, bodyString);
            result = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(json);

        } else if("access_denied".equals(json.get("error"))) {
            log.info("access_denied은 API 접근 권한이 없는 경우입니다.");
            log.info("코드에프 대시보드의 API 설정을 통해 해당 업무 접근 권한을 설정해야 합니다.");
        }

        return result;
    }
}