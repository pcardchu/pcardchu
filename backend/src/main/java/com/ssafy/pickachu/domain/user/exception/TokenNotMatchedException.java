package com.ssafy.pickachu.domain.user.exception;

public class TokenNotMatchedException extends RuntimeException {

    public TokenNotMatchedException() {
        super("TokenNotMatchedException");
    }
}

