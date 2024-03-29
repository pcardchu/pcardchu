package com.ssafy.pickachu.domain.auth.jwt;

import com.ssafy.pickachu.domain.auth.PrincipalDetails;
import com.ssafy.pickachu.domain.user.dto.UserDto;
import com.ssafy.pickachu.global.exception.ErrorCode;
import com.ssafy.pickachu.global.exception.ExceptionUtil;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.security.SignatureException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@AllArgsConstructor
@Slf4j
public class FirstJwtFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final ExceptionUtil exceptionUtil;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

        String requestUri = request.getRequestURI();

        if (!requestUri.equals("/api/user/basic-info")
                && !requestUri.equals("/api/user/login/password")
                && !requestUri.equals("/api/user/login/bio")
                && !requestUri.equals("/api/user/login/temp")){
            filterChain.doFilter(request, response);
            return;
        }

        String jwtHeader = request.getHeader("Authorization");

        log.info("=====1st JwtFilter: header: " + jwtHeader);

        // JWT Token을 검증하여 정상적인 사용자인지 확인
        if (jwtHeader == null || !jwtHeader.startsWith("Bearer")){
            exceptionUtil.setErrorResponse(response, ErrorCode.ILLEGAL_ARG_TOKEN);
            return;
        }

        String token = jwtHeader.replace("Bearer ", "");

        try {
            jwtUtil.validateAccessToken(token, true);
        }
        catch (ExpiredJwtException e){
            exceptionUtil.setErrorResponse(response, ErrorCode.EXPIRED_TOKEN);
            return;
        }catch (SignatureException e){
            exceptionUtil.setErrorResponse(response, ErrorCode.INVALID_SIGNATURE_TOKEN);
            return;
        }catch (MalformedJwtException e){
            exceptionUtil.setErrorResponse(response, ErrorCode.MALFORMED_TOKEN);
            return;
        }catch (UnsupportedJwtException e){
            exceptionUtil.setErrorResponse(response, ErrorCode.UNSUPPORTED_TOKEN);
            return;
        }catch (IllegalArgumentException e){
            exceptionUtil.setErrorResponse(response, ErrorCode.ILLEGAL_ARG_TOKEN);
            return;
        }
        catch(Exception e){
            log.error(e.toString());
            return;
        }

        Long id = jwtUtil.getIdFromAccessToken(token, true);
        String role = jwtUtil.getRole(token, true);

        if (id != null){
            // Authentication 생성
            PrincipalDetails principalDetails = new PrincipalDetails(new UserDto(id, role));
            Authentication authentication = new UsernamePasswordAuthenticationToken(principalDetails, null, principalDetails.getAuthorities());

            // 시큐리티 세션에 접근하여 Authentication 객체 저장
            SecurityContextHolder.getContext().setAuthentication(authentication);

            filterChain.doFilter(request, response);
        }
    }

}
