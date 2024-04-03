package com.ssafy.pickachu.serviceImpl;

import com.ssafy.pickachu.dto.top3category.dto.Top3Category;
import com.ssafy.pickachu.dto.top3category.response.Top3CategoryResponse;
import com.ssafy.pickachu.entity.Top3CategoryEntity;
import com.ssafy.pickachu.repository.Top3CategoryEntityRepository;
import com.ssafy.pickachu.service.Top3CategoryService;
import com.ssafy.pickachu.util.IndustryCode;
import jnr.ffi.annotations.In;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class Top3CategoryServiceImpl implements Top3CategoryService {
    private final Top3CategoryEntityRepository top3CategoryEntityRepository;
    private IndustryCode code = IndustryCode.getInstance();

    @Override
    public ResponseEntity<Top3CategoryResponse> getTop3Categories() {
        List<Top3CategoryEntity> top3categories =  top3CategoryEntityRepository.findAll();
        Collections.sort(top3categories);

        HashMap<CategoryKey, Top3Category> hm = new HashMap<CategoryKey, Top3Category>();
        for(Top3CategoryEntity entity : top3categories){
            CategoryKey categoryKey = new CategoryKey(entity.getAge(), entity.getGender());

            int categoryCode = Integer.parseInt(entity.getCategory());
            if(hm.get(categoryKey) == null){
                Top3Category t3c = new Top3Category(categoryKey.age, categoryKey.gender);
                t3c.getCategoryList().add(code.industryCodeHashMap.getOrDefault(categoryCode, "기타"));
                hm.put(categoryKey, t3c);
            }else{
                Top3Category t3c =  hm.get(categoryKey);
                t3c.getCategoryList().add(code.industryCodeHashMap.getOrDefault(categoryCode, "기타"));
                hm.put(categoryKey, t3c);
            }

        }

        List<Top3Category> values = hm.values().stream().toList();

        Top3CategoryResponse response = Top3CategoryResponse
                .createTop3CategoryResponse(
                        HttpStatus.OK.value(), "Success", values
                );

        return ResponseEntity.ok(response);

    }

    @Data
    static class CategoryKey{
        String age; String gender;

        public CategoryKey(String age, String gender) {
            this.age = age; this.gender = gender;
        }
    }
}