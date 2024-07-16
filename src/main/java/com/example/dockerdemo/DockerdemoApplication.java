package com.example.dockerdemo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalTime;

@RestController
@SpringBootApplication
public class DockerdemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DockerdemoApplication.class, args);
	}

	@GetMapping("/")
	public String home() {
		var t = LocalTime.now();
		System.out.println(t + " GET request to /");
		return "Hello J23-E02 @ " + t;
	}
}
