package com.ssafy.pickachu.domain.cards.recommend.entity;


import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;
import java.util.Map;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Document(collection = "card_info")
public class CardInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private String id;
    private String cardId;
    private List<String> categories;
    private List<String> annualFeeInfo;
    private Map<String, List<Object>> contents;
    private List<String> groupCategory;

}
