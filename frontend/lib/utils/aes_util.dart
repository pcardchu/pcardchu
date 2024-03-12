import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AesUtil {
  static final _aesKey = dotenv.env['AES_KEY'] ?? 'key오류';
  static final _key = encrypt.Key.fromUtf8(_aesKey); // 16자리 비밀키
  static final _iv = encrypt.IV.fromLength(16); // 16자리 IV (CBC 모드에 필요)

  // 데이터 암호화
  static String encryptAES(String? plainText) {
    if(_aesKey == 'key오류' || plainText == null) {
      print("env aes key 오류");
      return "env aes key 오류";
    }
    else {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
      final encrypted = encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    }
  }

  // 데이터 복호화
  static String decryptAES(String encryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedText), iv: _iv);
    return decrypted;
  }
}