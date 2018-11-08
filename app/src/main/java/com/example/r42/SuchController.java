package com.example.r42;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.ResponseEntity;

@RestController
public class SuchController {

	@Value("${suchname}") private String suchName;

	RestTemplate restTemplate = new RestTemplate();
    ResponseEntity<String> response = restTemplate.getForEntity("http://172.17.0.2:3333/date", String.class);
	String date = response.getBody();

	@RequestMapping("/hello")
	public String suchHello(){
		return "hello " + suchName + " it's " + date;
	}
}
