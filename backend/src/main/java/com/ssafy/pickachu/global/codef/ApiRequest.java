package com.ssafy.pickachu.global.codef;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.ssafy.pickachu.global.exception.ErrorCode;
import com.ssafy.pickachu.global.exception.ErrorException;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *  API 요청 템플릿 클래스
 */

@Slf4j
public class ApiRequest {
	
	private static ObjectMapper mapper = new ObjectMapper();
	private static Gson gson = new Gson();
	public static String reqeust(String urlPath, HashMap<String, Object> bodyMap, String PUBLIC_KEY, String CLIENT_ID, String SECERET_KEY, String ACCESS_TOKEN) throws IOException, InterruptedException, ParseException {
		// 리소스서버 접근을 위한 액세스토큰 설정(기존에 발급 받은 토큰이 있다면 유효기간 만료까지 재사용)
		String accessToken = ACCESS_TOKEN;
		
		// POST요청을 위한 리퀘스트바디 생성(UTF-8 인코딩)
		String bodyString = mapper.writeValueAsString(bodyMap);
		bodyString = URLEncoder.encode(bodyString, "UTF-8");

		// API 요청
		JSONObject json = (JSONObject)HttpRequest.post(urlPath, accessToken, bodyString);
		log.info(json.toJSONString());
		// 새로운 은행 추가 에러 리턴
		String code = (String) ((Map<String, Object>)json.get("result")).get("code");
		
		// XXX 에러 리턴
		if(code.equals("CF-04000") && urlPath.equals(CommonConstant.TEST_DOMAIN+CommonConstant.ADD_ACCOUNT)){
			JSONArray errorListArray = (JSONArray) ((Map<String, Object>)json.get("data")).get("errorList");
			String errorMSG = (String) ((Map<String, Object>)errorListArray.get(0)).get("message");
			if(errorMSG.equals("이미 계정이 등록된 기관입니다. 기존 계정 먼저 삭제하세요.")){
				throw new ErrorException(ErrorCode.EXIST_BANK_INFO);
			}
		// 리스트 가져오기 성공 했을 때..
		} else if (code.equals("CF-00000") && urlPath.equals(CommonConstant.TEST_DOMAIN+CommonConstant.GET_ACCOUNTS)){
			JSONArray data1 = (JSONArray) ((Map<String, Object>)json.get("data")).get("accountList");
			List<String> testOye = new ArrayList<>();
			for (Object o : data1) {
				JsonObject jsonObject = gson.fromJson(o.toString(), JsonObject.class);
				testOye.add(String.valueOf(jsonObject.get("organization")));
			}
			return testOye.toString();
		}
		// 다른 에러가 있으면 아래에 추가


		// 액세스 토큰 유효기간 만료시
		if("invalid_token".equals(json.get("error"))) {
			// 토큰 재발급 요청 수행
			accessToken = RequestToken.getToken(CLIENT_ID, SECERET_KEY);
			
			// API 재요청
			json = (JSONObject)HttpRequest.post(urlPath, accessToken, bodyString);

		} else if("access_denied".equals(json.get("error"))) {
			log.info("access_denied은 API 접근 권한이 없는 경우입니다.");
			log.info("코드에프 대시보드의 API 설정을 통해 해당 업무 접근 권한을 설정해야 합니다.");
		}



		String connectedId = ((Map<String,Object>)json.get("data")).get("connectedId").toString();
		return connectedId;
	}




	
}
