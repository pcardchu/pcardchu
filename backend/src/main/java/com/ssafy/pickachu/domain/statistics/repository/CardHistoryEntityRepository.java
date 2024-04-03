package com.ssafy.pickachu.domain.statistics.repository;

import com.ssafy.pickachu.domain.statistics.dto.SimpleCardHistory;
import com.ssafy.pickachu.domain.statistics.entity.CardHistoryEntity;
import com.ssafy.pickachu.domain.statistics.entity.MyConsumptionEntity;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

@Repository
public interface CardHistoryEntityRepository extends CassandraRepository<CardHistoryEntity, Integer> {
    @Query("SELECT * FROM cardhistory WHERE userid = :userid ALLOW FILTERING")
    List<CardHistoryEntity> findMyCardHistoryById(@Param("userid") int userid);


    @Query("SELECT * FROM cardhistory WHERE date >= :startDate AND date <= :endDate ALLOW FILTERING")
    List<CardHistoryEntity> findAllByDateRangeOrderedByDateAndTimeDesc2(
        @Param("startDate") String startDate,
        @Param("endDate") String endDate
    );
}
