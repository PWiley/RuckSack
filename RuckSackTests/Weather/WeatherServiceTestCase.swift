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
        let tempExpected = 283.8
        let humidityExpected = 73
        let consumer = WeatherConsumerFake()
        weatherService.delegate = consumer
        let expectation = XCTestExpectation(description: "Wait for info")
        consumer.didRetrieveWeather = { (openWeather) in
            XCTAssertEqual(openWeather.list[0].main.temp, tempExpected)
            XCTAssertEqual(openWeather.list[0].main.humidity, humidityExpected)
            expectation.fulfill()
        }
        weatherService.askWeatherState(town: weatherService.berlin)
        wait(for: [expectation], timeout: 3.0)

    }
    func testSetTimeIfFailed() {
        let weatherService = WeatherService(weatherSession: URLSessionWeatherFake(data: WeatherDataResponseFake.weatherCorrectData, response: WeatherDataResponseFake.responseCorrect, error: nil))
        let timestamp = 1573160400
        let night = weatherService.checkDayState(timestamp: Double(timestamp))
        XCTAssertEqual(night, true)
        
        
    }
    func testSetTimeIfSuccess() {
        let weatherService = WeatherService(weatherSession: URLSessionWeatherFake(data: WeatherDataResponseFake.weatherCorrectData, response: WeatherDataResponseFake.responseCorrect, error: nil))
        let timestamp = 1573138800
        let night = weatherService.checkDayState(timestamp: Double(timestamp))
        XCTAssertEqual(night, false)
        
        
    }
}

class WeatherConsumerFake: WeatherServiceDelegate{
    var didRetrieveWeather: ((OpenWeather) -> Void)?
    func didUpdateWeatherData(openWeather: OpenWeather) {
        didRetrieveWeather!(openWeather)
    }
    
    func didHappenedError(error: NetworkError) {
        
    }
    
    
}

