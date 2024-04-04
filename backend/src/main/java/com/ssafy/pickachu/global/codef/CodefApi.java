package com.ssafy.pickachu.global.codef;


import com.ssafy.pickachu.domain.cards.personalcards.dto.RegisterCardsReq;
import com.ssafy.pickachu.domain.user.entity.User;
import com.ssafy.pickachu.global.util.JasyptUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.codec.binary.Base64;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.text.SimpleDateFormat;
import java.util.*;


@Component
@Slf4j
@RequiredArgsConstructor
public class CodefApi {

    /**	CODEF로부터 발급받은 클라이언트 아이디	*/
    @Value("${codef.client-id}")
    private String CLIENT_ID;

    /**	CODEF로부터 발급받은 시크릿 키	*/
    @Value("${codef.secret-key}")
    private String SECERET_KEY;

    @Value("${codef.public-key}")
    private String PUBLIC_KEY;
    /**	CODEF로부터 발급받은 퍼블릭 키	*/

    private final JasyptUtil jasyptUtil;

    private static Map<String, String> BANK_CODE = new HashMap<>(){{
        put("KB카드", "0301");
        put("우리카드", "0309");
        put("현대카드", "0302");
        put("롯데카드", "0311");
        put("삼성카드", "0303");
        put("하나카드", "0313");
        put("NH카드", "0304");
        put("전북카드", "0315");
        put("BC카드", "0305");
        put("광주카드", "0316");
        put("신한카드", "0306");
        put("수협카드", "0320");
        put("제주카드", "0321");
        put("씨티카드", "0307");
        put("산업은행카드", "0002");
    }};


    public String GetToken(){
        try {
            // HTTP 요청을 위한 URL 오브젝트 생성
            URL url = new URL(CommonConstant.TOKEN_DOMAIN + CommonConstant.GET_TOKEN);

            String POST_PARAMS = "grant_type=client_credentials&scope=read";	// Oauth2.0 사용자 자격증명 방식(client_credentials) 토큰 요청 설정

            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE);

            // 클라이언트아이디, 시크릿코드 Base64 인코딩
            String auth = CLIENT_ID + ":" + SECERET_KEY;
            byte[] authEncBytes = Base64.encodeBase64(auth.getBytes());
            String authStringEnc = new String(authEncBytes);
            String authHeader = "Basic " + authStringEnc;

            con.setRequestProperty("Authorization", authHeader);
            con.setDoOutput(true);

            // 리퀘스트 바디 전송
            OutputStream os = con.getOutputStream();
            os.write(POST_PARAMS.getBytes());
            os.flush();
            os.close();

            // 응답 코드 확인
            int responseCode = con.getResponseCode();
            BufferedReader br;
            if (responseCode == HttpURLConnection.HTTP_OK) {	// 정상 응답
                br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            } else {	 // 에러 발생
                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
            }

            // 응답 바디 read
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
                response.append(inputLine);
            }
            br.close();

            // 응답 문자열 인코딩, JSONObject 변환
            JSONParser parser = new JSONParser();
            Object obj = parser.parse(URLDecoder.decode(response.toString(), "UTF-8"));
            JSONObject tokenJson = (JSONObject)obj;


            // 토큰 반환
            return tokenJson.get("access_token").toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }



    public String GetConnectedToken(RegisterCardsReq registerCardsReq, String ACCESS_TOKEN) throws NoSuchPaddingException, IllegalBlockSizeException, NoSuchAlgorithmException, InvalidKeySpecException, BadPaddingException, InvalidKeyException, IOException, ParseException, InterruptedException {


        String urlPath = "https://development.codef.io/v1/account/create";

        HashMap<String, Object> bodyMap = new HashMap<String, Object>();
        List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();

        HashMap<String, Object> accountMap2 = new HashMap<String, Object>();
        accountMap2.put("countryCode",	"KR");
        accountMap2.put("businessType",	"CD");
        accountMap2.put("clientType",  	"P");
        accountMap2.put("organization",	BANK_CODE.get(registerCardsReq.getCardCompany()));
        accountMap2.put("loginType",  	"1");


        String password2 = registerCardsReq.getCardCompanyPw();

        accountMap2.put("password", RSAUtil.encryptRSA(password2, PUBLIC_KEY));	/**	password RSA encrypt */


        accountMap2.put("id",  		registerCardsReq.getCardCompanyId());
        accountMap2.put("birthday",	"YYMMDD");
        list.add(accountMap2);

        bodyMap.put("accountList", list);

        //CODEF API 호출

        return ApiRequest.reqeust(urlPath, bodyMap, PUBLIC_KEY, CLIENT_ID, SECERET_KEY, ACCESS_TOKEN);
    }

    public String AddBankInConnectedId(RegisterCardsReq registerCardsReq, User user, String ACCESS_TOKEN) throws NoSuchPaddingException, IllegalBlockSizeException, NoSuchAlgorithmException, InvalidKeySpecException, BadPaddingException, InvalidKeyException, IOException, ParseException, InterruptedException {
        String urlPath = "https://development.codef.io/v1/account/add";

        HashMap<String, Object> bodyMap = new HashMap<String, Object>();
        List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();

        HashMap<String, Object> accountMap2 = new HashMap<String, Object>();
        accountMap2.put("countryCode",	"KR");  // 국가코드
        accountMap2.put("businessType",	"CD");  // 업무구분코드 (CD: 카드, BK: 은행)
        accountMap2.put("clientType",  	"P");   // 고객구분(P: 개인, B: 기업)
        accountMap2.put("organization",	BANK_CODE.get(registerCardsReq.getCardCompany())); // 기관코드 (0313: 하나카드, )
        accountMap2.put("loginType",  	"1");   // 로그인타입 (0: 인증서, 1: ID/PW)

        String password2 = registerCardsReq.getCardCompanyPw();   //기관 PW
        accountMap2.put("password", RSAUtil.encryptRSA(password2, PUBLIC_KEY));	/**	password RSA encrypt */

        accountMap2.put("id",  		registerCardsReq.getCardCompanyId()); //기관 ID
        accountMap2.put("birthday",	"YYMMDD"); //생년월일
        list.add(accountMap2);

        String connectedId = jasyptUtil.decrypt(user.getConnectedId());
        bodyMap.put("connectedId", connectedId);

        bodyMap.put("accountList", list);

//CODEF API 호출
        return ApiRequest.reqeust(urlPath, bodyMap, PUBLIC_KEY, CLIENT_ID, SECERET_KEY, ACCESS_TOKEN);

    }

    public String GetUseCardList(RegisterCardsReq registerCardsReq, User user, String ACCESS_TOKEN, String startDate, String endDate) throws IOException, ParseException, InterruptedException {

        String urlPath = "https://development.codef.io/v1/kr/card/p/account/approval-list";

        // 요청 파라미터 설정 시작
        HashMap<String, Object> bodyMap = new HashMap<String, Object>();
        bodyMap.put("connectedId", jasyptUtil.decrypt(user.getConnectedId()));	// 엔드유저의 은행/카드사 계정 등록 후 발급받은 커넥티드아이디 예시
        bodyMap.put("organization", BANK_CODE.get(registerCardsReq.getCardCompany())); //하나 카드

        Date userBirth = user.getBirth();
        SimpleDateFormat outputFormat = new SimpleDateFormat("yyMMdd");
        String formattedDate = outputFormat.format(userBirth);
        bodyMap.put("birthDate", formattedDate);


        bodyMap.put("startDate", startDate);
        bodyMap.put("endDate", endDate);
        bodyMap.put("orderBy", "0"); //과거순
        bodyMap.put("inquiryType", "0"); //"0"인 경우, 보유카드 조회 결과의 카드명을 사용
        String cardNo = registerCardsReq.getCardNo();//.replace("-", "");

        bodyMap.put("cardNo", cardNo); //카드 번호
        bodyMap.put("memberStoreInfoType" ,"3"); //"0": 미포함, "1": 가맹점 포함, "2":부가세 포함, "3":전체 (가맹점 +부가세) 포함 (default: "0")
        // 요청 파라미터 설정 종료

        // API 요청
        String result = SandboxApiRequest.reqeust(urlPath, bodyMap, ACCESS_TOKEN);	//  샌드박스 요청
        return result;
    }

    public String GetCardsName(RegisterCardsReq registerCardsReq, User user, String ACCESS_TOKEN) throws IOException, ParseException, InterruptedException {

        String urlPath = "https://development.codef.io" + CommonConstant.KR_CD_P_001;

        // 요청 파라미터 설정 시작
        HashMap<String, Object> bodyMap = new HashMap<String, Object>();
        bodyMap.put("connectedId", jasyptUtil.decrypt(user.getConnectedId()));	// 엔드유저의 은행/카드사 계정 등록 후 발급받은 커넥티드아이디 예시
        bodyMap.put("organization", BANK_CODE.get(registerCardsReq.getCardCompany())); //하나 카드
        bodyMap.put("birthDate", "");
        // 요청 파라미터 설정 종료

        // API 요청
        String result = SandboxApiRequest.reqeust(urlPath, bodyMap, ACCESS_TOKEN);	//  샌드박스 요청 오브젝트 사용
        return result;
    }

}
