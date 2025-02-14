package com.ssafy.pickachu.domain.cards.recommend.mapper;

import com.ssafy.pickachu.domain.cards.personalcards.dto.SimplePersonalCardsRes;
import com.ssafy.pickachu.domain.cards.personalcards.entity.PersonalCards;
import com.ssafy.pickachu.domain.cards.recommend.dto.CardsRes;
import com.ssafy.pickachu.domain.cards.recommend.entity.Cards;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface CardsMapper {

    @Mapping(source = "id", target = "cardId")
    @Mapping(source = "imageUrl", target = "cardImg")
    CardsRes toCardsRes(Cards cards);
}
