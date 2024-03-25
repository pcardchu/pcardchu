package com.ssafy.pickachu.repository;

import com.ssafy.pickachu.entity.PeakTimeAgeEntity;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PeakTimeAgeEntityRepository extends CassandraRepository<PeakTimeAgeEntity, Integer> {

}
