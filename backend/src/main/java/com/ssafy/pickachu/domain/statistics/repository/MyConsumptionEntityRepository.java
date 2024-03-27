package com.ssafy.pickachu.domain.statistics.repository;

import com.ssafy.pickachu.domain.statistics.entity.MyConsumptionEntity;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MyConsumptionEntityRepository extends CassandraRepository<MyConsumptionEntity, Integer> {
    @Query("SELECT * FROM myconsumption WHERE userid = :userid ALLOW FILTERING")
    List<MyConsumptionEntity> findMyConsumptionById(@Param("userid") int userid);
}
