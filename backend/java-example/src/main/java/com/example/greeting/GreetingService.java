package com.example.javaexample;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Example service class demonstrating basic Java backend functionality.
 */
public class GreetingService {
    private static final Logger logger = LoggerFactory.getLogger(GreetingService.class);
    
    /**
     * Generate a greeting message.
     * 
     * @param name The name to greet
     * @return A greeting message
     */
    public String greet(String name) {
        if (name == null || name.trim().isEmpty()) {
            name = "World";
        }
        
        String message = "Hello, " + name + "!";
        logger.debug("Generated greeting: {}", message);
        return message;
    }
    
    /**
     * Generate a formal greeting message.
     * 
     * @param title The title (Mr., Ms., Dr., etc.)
     * @param name The name to greet
     * @return A formal greeting message
     */
    public String greetFormal(String title, String name) {
        if (title == null || title.trim().isEmpty()) {
            title = "";
        } else {
            title = title.trim() + " ";
        }
        
        if (name == null || name.trim().isEmpty()) {
            name = "Guest";
        }
        
        String message = "Good day, " + title + name + "!";
        logger.debug("Generated formal greeting: {}", message);
        return message;
    }
}