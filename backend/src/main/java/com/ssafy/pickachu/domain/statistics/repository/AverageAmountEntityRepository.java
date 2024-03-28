package com.ssafy.pickachu.domain.statistics.repository;

import com.ssafy.pickachu.domain.statistics.entity.AverageAmountEntity;
import com.ssafy.pickachu.domain.statistics.entity.MyConsumptionEntity;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AverageAmountEntityRepository extends CassandraRepository<AverageAmountEntity, Integer> {
}
