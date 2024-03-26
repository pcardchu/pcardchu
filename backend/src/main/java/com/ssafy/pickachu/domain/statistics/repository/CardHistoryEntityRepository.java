package com.ssafy.pickachu.domain.statistics.repository;

import com.ssafy.pickachu.domain.statistics.entity.CardHistoryEntity;
import com.ssafy.pickachu.domain.statistics.entity.MyTop3Entity;
import com.ssafy.pickachu.domain.statistics.entity.PeakTimeAgeEntity;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CardHistoryEntityRepository extends CassandraRepository<CardHistoryEntity, Integer> {

}
