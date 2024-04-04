package com.ssafy.pickachu.domain.user.service;

import com.ssafy.pickachu.domain.user.entity.User;
import com.ssafy.pickachu.domain.user.exception.UserNotFoundException;
import com.ssafy.pickachu.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.thymeleaf.context.Context;
import org.thymeleaf.spring6.SpringTemplateEngine;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;

@Slf4j
@RequiredArgsConstructor
@Service
public class EmailService {
    private final SpringTemplateEngine templateEngine;
    private final JavaMailSender javaMailSender;
    private final UserRepository userRepository;

    @Value("${mail-templates.file}")
    private String mailFilePath;

    @Transactional
    public boolean sendEmail(Long id){

        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException());

        MimeMessagePreparator preparator = mimeMessage -> {
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

            String pw = String.valueOf(randomPassword());
            String hashPw = hashPassword(pw, String.valueOf(id));
            user.setShortPw(hashPw);
            user.setPwWrongCount(0);
            user.setFlagBiometrics(0);

            HashMap<String, Object> templateModel = new HashMap<>();
            templateModel.put("tempPassword", pw);
            Context thymeleafContext = new Context();
            thymeleafContext.setVariables(templateModel);
            String htmlBody = templateEngine.process(mailFilePath, thymeleafContext);

            helper.setTo(user.getEmail());
            helper.setSubject("[Pickachu] 임시 비밀번호 발급");
            helper.setText(htmlBody, true);

        };

        try {
            javaMailSender.send(preparator);
            return true;
        }catch (MailException e) {
            e.printStackTrace();
            return false;
        }
    }

    int randomPassword(){
        return (int) (Math.random() * 899999 + 100000);
    }

    static String hashPassword(String value, String salt){
        try {
            log.info(value +" "+ salt);
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest((value + salt).getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }
}
