package com.ssafy.pickachu.controller;

import com.ssafy.pickachu.dto.top3category.response.Top3CategoryResponse;
import com.ssafy.pickachu.service.Top3CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@CrossOrigin("*")
@RequestMapping("api/statistics")
public class StatisticsController {

    private final Top3CategoryService top3CategoryEntityService;

    @GetMapping("/top3category")
    public ResponseEntity<Top3CategoryResponse> getTop3Categories() {
        return top3CategoryEntityService.getTop3Categories();
    }
}