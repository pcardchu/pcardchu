package com.ssafy.pickachu.global.util;

import org.jasypt.encryption.StringEncryptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class JasyptUtil {

    @Autowired
    private StringEncryptor jasyptStringEncryptor;

    // 주어진 문자열을 암호화하여 반환하는 메서드
    public String encrypt(String input) {
        return jasyptStringEncryptor.encrypt(input);
    }

    // 암호화된 문자열을 복호화하여 반환하는 메서드
    public String decrypt(String encryptedInput) {
        return jasyptStringEncryptor.decrypt(encryptedInput);
    }
}