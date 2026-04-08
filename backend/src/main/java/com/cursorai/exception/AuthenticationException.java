package com.cursorai.exception;

/**
 * Custom Authentication Exception
 * 
 * Exception thrown when authentication fails.
 */
public class AuthenticationException extends RuntimeException {
    
    public AuthenticationException(String message) {
        super(message);
    }
    
    public AuthenticationException(String message, Throwable cause) {
        super(message, cause);
    }
}
