package com.ssafy.pickachu.domain.statistics.repository;

import com.ssafy.pickachu.domain.statistics.entity.PeakTimeAgeEntity;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PeakTimeAgeEntityRepository extends CassandraRepository<PeakTimeAgeEntity, Integer> {

}
