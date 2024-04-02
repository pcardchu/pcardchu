import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CryptoUtil {
  static final _aesKey = dotenv.env['AES_KEY'] ?? 'key오류';
  static final _key = encrypt.Key.fromBase64(_aesKey); // 16자리 비밀키
  static final iv = encrypt.IV.fromLength(16); // 16자리 IV (CBC 모드에 필요)


  // 데이터 암호화
  static String encryptAES(String? plainText) {
    print("iv : ${iv.base64}");

    if(_aesKey == 'key오류' || plainText == null) {
      print("env aes key 오류");
      return "env aes key 오류";
    }
    else {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      final encrypted = encrypter.encrypt(plainText, iv: iv);

      return encrypted.base64;
    }
  }

  // 데이터 복호화
  static String decryptAES(String encryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedText), iv: iv);
    return decrypted;
  }

  //해싱
  static String hashPassword(String value, int salt) {
    Uint8List bytes = utf8.encode("$value$salt");
    Digest digest = sha256.convert(bytes);

    return digest.toString();
  }

  static int? extractIdFromAccessToken(String accessToken) {
    try {
      // JWT는 세 부분으로 구성되어 있습니다. 페이로드 부분을 분리합니다.
      final payloadBase64 = accessToken.split('.')[1];
      // Base64 문자열을 정상적인 Base64로 변경합니다. JWT Base64Url을 Base64로 변경
      var normalizedBase64 = base64Url.normalize(payloadBase64);
      // Base64 디코딩을 수행합니다.
      var decodedJson = utf8.decode(base64Url.decode(normalizedBase64));
      // 디코딩된 JSON 문자열을 Map으로 변환합니다.
      var decodedPayload = json.decode(decodedJson);
      // id 값을 추출합니다.
      if (decodedPayload is Map<String, dynamic> && decodedPayload.containsKey('id')) {
        return decodedPayload['id'];
      }
    } catch (e) {
      print("Error extracting id from accessToken: $e");
      return null;
    }
    return null;
  }

  ///AccessToken에서 만료기한을 추출합니다.
  static int? extractExpFromAccessToken(String accessToken) {
    try {
      // JWT는 세 부분으로 구성되어 있습니다. 페이로드 부분을 분리합니다.
      final payloadBase64 = accessToken.split('.')[1];
      // Base64 문자열을 정상적인 Base64로 변경합니다. JWT Base64Url을 Base64로 변경
      var normalizedBase64 = base64Url.normalize(payloadBase64);
      // Base64 디코딩을 수행합니다.
      var decodedJson = utf8.decode(base64Url.decode(normalizedBase64));
      // 디코딩된 JSON 문자열을 Map으로 변환합니다.
      var decodedPayload = json.decode(decodedJson);
      // exp 값을 추출합니다.
      if (decodedPayload is Map<String, dynamic> && decodedPayload.containsKey('exp')) {
        return decodedPayload['exp'];
      }
    } catch (e) {
      print("Error extracting exp from accessToken: $e");
      return null;
    }
    return null;
  }
}