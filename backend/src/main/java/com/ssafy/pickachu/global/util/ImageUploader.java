package com.ssafy.pickachu.global.util;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.net.URL;

@Component
@Slf4j
public class ImageUploader {

    @Value("${image.upload.path}")
    String UPLOAD_URL_PATH;
    // test용 주석

    public String ImgaeUpload(String imgUrl, String fileName, String extension){

        BufferedImage image = null;
        String fileNm = fileName+"."+extension;
        try {
            image = ImageIO.read(new URL(imgUrl));
            File file = new File(UPLOAD_URL_PATH + fileNm);
            ImageIO.write(image, extension, file);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return UPLOAD_URL_PATH + fileNm;
    }


}
