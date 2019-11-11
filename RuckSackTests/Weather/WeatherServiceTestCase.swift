//
//  WeatherServiceTestCase.swift
//  RuckSackTests
//
//  Created by Patrick Wiley on 07.11.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//
//
import XCTest
@testable import RuckSack

class WeatherServiceTestCase: XCTestCase, WeatherServiceDelegate {
    
    var expectation: XCTestExpectation!
    func didUpdateWeatherData(openWeather: OpenWeather) {
        expectation.fulfill()
    }
    
    func didHappenedError(error: NetworkError) {
        
    }
    

    func testGetWeatherShouldPostFailedIfError() {
        //Given=
        let weatherService = WeatherService(weatherSession: URLSessionWeatherFake(data: nil, response: nil, error: WeatherDataResponseFake.error))
        //When
        weatherService.askWeatherState(town: weatherService.berlin)
        //Then
        XCTAssertTrue(weatherService.openWeather == nil)
    }
    func testGetWeatherShouldPostFailedNoData() {
        //Given=
        let weatherService = WeatherService(weatherSession: URLSessionWeatherFake(data: nil, response: nil, error: nil))
        //When
        weatherService.askWeatherState(town: weatherService.berlin)
        //Then
        XCTAssertTrue(weatherService.openWeather == nil)
    }
    func testGetWeatherShouldPostFailedIfIncorrectResponse() {
            //Given=
        let weatherService = WeatherService(weatherSession: URLSessionWeatherFake(data: WeatherDataResponseFake.weatherCorrectData, response: WeatherDataResponseFake.responseIncorrect, error: nil))
            //When
            weatherService.askWeatherState(town: weatherService.berlin)
            //Then
            XCTAssertTrue(weatherService.openWeather == nil)
        }
    func testGetWeatherShouldPostFailedIfIncorrectData() {
        //Given=
    let weatherService = WeatherService(weatherSession: URLSessionWeatherFake(data: WeatherDataResponseFake.weatherIncorrectData, response: WeatherDataResponseFake.responseCorrect, error: nil))
        //When
        weatherService.askWeatherState(town: weatherService.berlin)
        //Then
        XCTAssertTrue(weatherService.openWeather == nil)
    }
    
    func testGetWeatherShouldPostSuccessIfNoErrorCorrectData() {
        //Given=
    let weatherService = WeatherService(weatherSession: URLSessionWeatherFake(data: WeatherDataResponseFake.weatherCorrectData,
                                                                              response: WeatherDataResponseFake.responseCorrect,
                                                                              error: nil))
        expectation = expectation(description: "Wait for info")
        weatherService.delegate = self
        //When
       
        //Then
        
        weatherService.askWeatherState(town: weatherService.berlin)
       
        waitForExpectations(timeout: 2)
        
        XCTAssertEqual(weatherService.openWeather?.list[0].main.temp, 283.8)
        XCTAssertEqual(73, weatherService.openWeather!.list[0].main.humidity)

    }
    func testSetTimeIfFailed() {
        let weatherService = WeatherService(weatherSession: URLSessionWeatherFake(data: WeatherDataResponseFake.weatherCorrectData, response: WeatherDataResponseFake.responseCorrect, error: nil))
        let timestamp = 1573160400
        let night = weatherService.setTime(timestamp: Double(timestamp))
        XCTAssertEqual(night, true)
        
        
    }
    func testSetTimeIfSuccess() {
        let weatherService = WeatherService(weatherSession: URLSessionWeatherFake(data: WeatherDataResponseFake.weatherCorrectData, response: WeatherDataResponseFake.responseCorrect, error: nil))
        let timestamp = 1573138800
        let night = weatherService.setTime(timestamp: Double(timestamp))
        XCTAssertEqual(night, false)
        
        
    }
}

