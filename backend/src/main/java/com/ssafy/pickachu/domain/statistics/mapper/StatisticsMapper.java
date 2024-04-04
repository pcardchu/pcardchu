package com.ssafy.pickachu.domain.statistics.mapper;


import com.ssafy.pickachu.domain.cards.personalcards.dto.SimplePersonalCardsRes;
import com.ssafy.pickachu.domain.cards.personalcards.entity.PersonalCards;
import com.ssafy.pickachu.domain.statistics.dto.SimpleCardHistory;
import com.ssafy.pickachu.domain.statistics.entity.CardHistoryEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface StatisticsMapper {


    CardHistoryEntity ToCardHistoryEntity(SimpleCardHistory simpleCardHistory);
    SimpleCardHistory ToSimpleCardHistory(CardHistoryEntity simpleCardHistory);
}
