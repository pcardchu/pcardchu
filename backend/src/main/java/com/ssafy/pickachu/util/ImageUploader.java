package com.ssafy.pickachu.util;

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

    public String ImgaeUpload(String imgUrl, String fileName ){

        BufferedImage image = null;
        String extension = imgUrl.substring(imgUrl.lastIndexOf('.') + 1);
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
