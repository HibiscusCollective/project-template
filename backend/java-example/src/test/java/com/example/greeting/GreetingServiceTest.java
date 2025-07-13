package com.example.javaexample;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.assertj.core.api.Assertions.assertThat;

/**
 * Unit tests for GreetingService.
 */
class GreetingServiceTest {
    
    private GreetingService greetingService;
    
    @BeforeEach
    void setUp() {
        greetingService = new GreetingService();
    }
    
    @Test
    void greet_withValidName_returnsPersonalizedGreeting() {
        // Given
        String name = "Alice";
        
        // When
        String result = greetingService.greet(name);
        
        // Then
        assertThat(result).isEqualTo("Hello, Alice!");
    }
    
    @Test
    void greet_withNullName_returnsDefaultGreeting() {
        // When
        String result = greetingService.greet(null);
        
        // Then
        assertThat(result).isEqualTo("Hello, World!");
    }
    
    @Test
    void greet_withEmptyName_returnsDefaultGreeting() {
        // When
        String result = greetingService.greet("   ");
        
        // Then
        assertThat(result).isEqualTo("Hello, World!");
    }
    
    @Test
    void greetFormal_withTitleAndName_returnsFormattedGreeting() {
        // Given
        String title = "Dr.";
        String name = "Smith";
        
        // When
        String result = greetingService.greetFormal(title, name);
        
        // Then
        assertThat(result).isEqualTo("Good day, Dr. Smith!");
    }
    
    @Test
    void greetFormal_withNullTitle_returnsGreetingWithoutTitle() {
        // Given
        String name = "Johnson";
        
        // When
        String result = greetingService.greetFormal(null, name);
        
        // Then
        assertThat(result).isEqualTo("Good day, Johnson!");
    }
    
    @Test
    void greetFormal_withNullName_returnsDefaultGuestGreeting() {
        // Given
        String title = "Mr.";
        
        // When
        String result = greetingService.greetFormal(title, null);
        
        // Then
        assertThat(result).isEqualTo("Good day, Mr. Guest!");
    }
}