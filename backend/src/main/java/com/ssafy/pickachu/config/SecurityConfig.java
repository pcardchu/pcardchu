package com.ssafy.pickachu.config;

import com.ssafy.pickachu.domain.auth.jwt.SecondJwtFilter;
import com.ssafy.pickachu.domain.user.repository.UserRepository;
import com.ssafy.pickachu.global.exception.ExceptionUtil;
import com.ssafy.pickachu.domain.auth.jwt.FirstJwtFilter;
import com.ssafy.pickachu.domain.auth.jwt.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.filter.CorsFilter;

@RequiredArgsConstructor
@EnableWebSecurity
@EnableMethodSecurity(securedEnabled = true)
@Configuration
public class SecurityConfig {

    private final CorsFilter corsFilter;
    private final JwtUtil jwtUtil;
    private final ExceptionUtil exceptionUtil;
    private final UserRepository userRepository;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception{
        http
                .csrf(csrf -> csrf.disable())
                .addFilter(corsFilter)
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .formLogin(form -> form.disable())
                .httpBasic(hb -> hb.disable())
                .addFilterBefore(new FirstJwtFilter(jwtUtil, exceptionUtil), UsernamePasswordAuthenticationFilter.class)
                .addFilterAfter(new SecondJwtFilter(jwtUtil, exceptionUtil), FirstJwtFilter.class)
                .authorizeHttpRequests(authz -> authz
                        .requestMatchers("/").permitAll()
                        .requestMatchers( "/swagger-ui.html", "/swagger-ui/**", "/v3/api-docs/**").permitAll()
                        .requestMatchers( "/auth-test/**").permitAll()
                        .requestMatchers("/user/login/kakao").permitAll()
                        .requestMatchers("/user/basic-info").hasAnyAuthority("ROLE_FIRST_AUTH")
                        .anyRequest().hasAnyAuthority("ROLE_SECOND_AUTH"));

        return http.build();
    }

}
