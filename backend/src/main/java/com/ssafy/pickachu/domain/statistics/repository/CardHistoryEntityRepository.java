package com.ssafy.pickachu.domain.statistics.repository;

import com.ssafy.pickachu.domain.statistics.entity.CardHistoryEntity;
import com.ssafy.pickachu.domain.statistics.entity.MyConsumptionEntity;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CardHistoryEntityRepository extends CassandraRepository<CardHistoryEntity, Integer> {
    @Query("SELECT * FROM cardhistory WHERE userid = :userid ALLOW FILTERING")
    List<CardHistoryEntity> findMyCardHistoryById(@Param("userid") int userid);
}
