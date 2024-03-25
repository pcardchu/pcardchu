package com.ssafy.pickachu.domain.statistics.repository;

import com.ssafy.pickachu.domain.statistics.entity.Top3CategoryEntity;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface Top3CategoryEntityRepository extends CassandraRepository<Top3CategoryEntity, Integer> {

}
