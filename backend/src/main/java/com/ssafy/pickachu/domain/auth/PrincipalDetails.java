package com.ssafy.pickachu.domain.auth;

import com.ssafy.pickachu.domain.user.dto.UserDto;
import com.ssafy.pickachu.domain.user.entity.User;
import lombok.Data;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;

// Security Session <= Authentication <= UserDetails (PrincipalDetails)
@Data
public class PrincipalDetails implements UserDetails{

    private UserDto userDto;
    private Map<String, Object> attributes;

    public PrincipalDetails(UserDto userDto){
        this.userDto = userDto;
    }

    // User 권한 리턴
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        Collection<GrantedAuthority> collection = new ArrayList<>();
        collection.add((GrantedAuthority) () -> userDto.getRole());
        return collection;
    }

    @Override
    public String getPassword() {
        return "";
    }

    @Override
    public String getUsername() {
        return "";
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {

        // 1년 동안 회원이 로그인을 안 하면 휴면 계정으로 처리하는 경우
        // 현재 시간 - 로그인 시간 => 1년 초과 시 return false;

        return true;
    }


}
