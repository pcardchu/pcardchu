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
  static String hashPassword(String value, String salt) {
    Uint8List bytes = utf8.encode(value + salt);
    Digest digest = sha256.convert(bytes);

    return digest.toString();
  }
}