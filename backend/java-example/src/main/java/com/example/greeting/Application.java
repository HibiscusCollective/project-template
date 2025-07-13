package com.example.javaexample;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Main application class for the Java example backend service.
 */
public class Application {
    private static final Logger logger = LoggerFactory.getLogger(Application.class);
    
    public static void main(String[] args) {
        logger.info("Starting Java example application...");
        
        GreetingService greetingService = new GreetingService();
        
        System.out.println("=== Java Backend Example ===");
        System.out.println(greetingService.greet("World"));
        System.out.println(greetingService.greet("Developer"));
        System.out.println("Java version: " + System.getProperty("java.version"));
        System.out.println("Application is running successfully.");
        
        logger.info("Java example application completed successfully");
    }
}