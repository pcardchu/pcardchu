package com.ssafy.pickachu.global.codef;

import lombok.extern.slf4j.Slf4j;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;


/**
 * RSA 암호화 유틸입니다.
 * 키사이즈는 Default로 2048을 사용하고 있습니다.
 * 유틸에서 생성된 키는 각각 인코딩된 String값으로 반환되어 사용됩니다.
 * 사용될 때는 각 키를 디코딩하여 각 키 인스턴스를 생성 후 암호화 또는 복호화에 사용됩니다.
 * 
 * @author choedongcheol
 *
 */
@Slf4j
public class RSAUtil {
	private static String ENCRYPT_TYPE_RSA = "RSA";

	/**
	 * /**
	 * 	 * Public Key로 RSA 암호화를 수행합니다.
	 * 	 *
	 * @param plainText 암호화할 평문입니다.
	 * @param base64PublicKey
	 * @return 암호화된 데이터 String
	 * @throws NoSuchAlgorithmException
	 * @throws InvalidKeySpecException
	 * @throws NoSuchPaddingException
	 * @throws InvalidKeyException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 */
	public static String encryptRSA(String plainText, String base64PublicKey) {
		try {
			log.info("Test2 " + 1);
			log.info("Test2.1 " + base64PublicKey);
//			String jwtOneLine = base64PublicKey.replaceAll(".", "");
//			log.info("TT  " + jwtOneLine);
			byte[] bytePublicKey = Base64.getDecoder().decode(base64PublicKey);
			KeyFactory keyFactory = KeyFactory.getInstance(ENCRYPT_TYPE_RSA);
			PublicKey publicKey = keyFactory.generatePublic(new X509EncodedKeySpec(bytePublicKey));

			Cipher cipher = Cipher.getInstance(ENCRYPT_TYPE_RSA);
			cipher.init(Cipher.ENCRYPT_MODE, publicKey);
			byte[] bytePlain = cipher.doFinal(plainText.getBytes());
			String encrypted = Base64.getEncoder().encodeToString(bytePlain);

			return encrypted;
		}
		catch (NoSuchAlgorithmException| InvalidKeySpecException| NoSuchPaddingException|
			InvalidKeyException| IllegalBlockSizeException| BadPaddingException e) {
			e.printStackTrace();
			return "HH";
		}

	}
	
}
