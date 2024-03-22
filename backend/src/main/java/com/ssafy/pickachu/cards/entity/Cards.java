package com.ssafy.pickachu.cards.entity;

import jakarta.persistence.Id;
import lombok.*;
import org.springframework.data.mongodb.core.mapping.Document;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Document(collection = "cards")
public class Cards {

    @Id
    private String id;
    //    private String cardNum;
    private String cardName;
    // 회사 아이디인데 안되면 회사 이름이라도 해서 넘어가자
    private String organization_id;
    private String imageName;
    private String imageUrl;
    private String registrationUrl;
}
