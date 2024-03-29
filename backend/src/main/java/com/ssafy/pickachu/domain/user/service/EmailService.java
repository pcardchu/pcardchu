package com.ssafy.pickachu.domain.user.service;

import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class EmailService {
    private final JavaMailSender javaMailSender;

    public boolean sendEmail(String email){
        MimeMessagePreparator preparator = new MimeMessagePreparator() {
            @Override
            public void prepare(MimeMessage mimeMessage) throws Exception {
                MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

                helper.setTo(email);
                helper.setSubject("[Pickachu] 임시 비밀번호 발급");
                helper.setText("임시 비밀번호는 ------ 입니다.");

            }
        };

        try {
            javaMailSender.send(preparator);
            return true;
        }catch (MailException e) {
            e.printStackTrace();
            return false;
        }
    }
}
