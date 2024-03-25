package com.ssafy.pickachu.repository;

import com.ssafy.pickachu.entity.Top3CategoryEntity;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface Top3CategoryEntityRepository extends CassandraRepository<Top3CategoryEntity, Integer> {

}
