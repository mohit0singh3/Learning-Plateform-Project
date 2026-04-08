package com.cursorai;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Main Spring Boot Application Class
 * 
 * This is the entry point of the CodeSphere Backend application.
 * Spring Boot will automatically configure and start the application.
 */
@SpringBootApplication
public class CursorAiApplication {

    public static void main(String[] args) {
        SpringApplication.run(CursorAiApplication.class, args);
        System.out.println("========================================");
        System.out.println("CodeSphere Backend Started Successfully!");
        System.out.println("API Base URL: http://localhost:8080/api");
        System.out.println("========================================");
    }
}
