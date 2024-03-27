package com.ssafy.pickachu.domain.user.exception;

public class UserNotFoundException extends RuntimeException {

    public UserNotFoundException() {
        super("UserNotFoundException");
    }
}

