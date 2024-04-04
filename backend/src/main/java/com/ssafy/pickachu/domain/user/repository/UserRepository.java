package com.ssafy.pickachu.domain.user.repository;

import com.ssafy.pickachu.domain.user.entity.User;
import com.ssafy.pickachu.domain.user.response.UserInfoRes;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

// CRUD 함수를 JpaRepository가 가지고 있음
// JpaRepository 상속 -> @Repository 어노테이션이 없어도 IoC
public interface UserRepository extends JpaRepository<User, Long>, UserRepositoryQuerydsl {
    public User findByIdentifier(String identifier);    // JPA Query Method
}
