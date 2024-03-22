package com.ssafy.pickachu.crawling.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BenefitCalc {
    private String benefitSummary;
    private String category;
    private String payType;
    @Builder.Default
    private long unit = 0;
    @Builder.Default
    private long discount  = 0;
}
