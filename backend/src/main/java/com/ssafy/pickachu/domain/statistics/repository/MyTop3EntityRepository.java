package com.ssafy.pickachu.domain.statistics.repository;

import com.ssafy.pickachu.domain.statistics.entity.CardHistoryEntity;
import com.ssafy.pickachu.domain.statistics.entity.MyTop3Entity;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MyTop3EntityRepository extends CassandraRepository<MyTop3Entity, Integer> {
    @Query("SELECT * FROM mytop3 WHERE userid = :userid ORDER BY id")
    List<MyTop3Entity> findTop3ById(@Param("userid") int userid);
}
