package com.ssafy.pickachu.domain.cards.personalcards.repository;

import com.ssafy.pickachu.domain.cards.personalcards.entity.CodefToken;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CodefRepository extends JpaRepository<CodefToken, Integer> {
}