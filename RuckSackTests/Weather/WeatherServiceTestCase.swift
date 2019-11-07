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

class WeatherServiceTestCase: XCTestCase {

    func testGetWeatherShouldPostFailedIfError() {
        //Given=
        let weatherService = WeatherService(weatherSession: URLSessionWeatherFake(data: nil, response: nil, error: WeatherDataResponseFake.error))
//        let berlin: [String: String] = [
//            "q": "berlin,de",
//            "mode": "json",
//            "appid": "d2fc02766020f446cb8063c244166041"
//        ]
        //When
        weatherService.askWeatherState(town: weatherService.berlin)
        //Then
        XCTAssertTrue(weatherService.openWeather == nil)
    }
    func testGetWeatherShouldPostFailedNoData() {
        //Given=
        let weatherService = WeatherService(weatherSession: URLSessionWeatherFake(data: nil, response: nil, error: nil))
//        let berlin: [String: String] = [
//            "q": "berlin,de",
//            "mode": "json",
//            "appid": "d2fc02766020f446cb8063c244166041"
//        ]
        //When
        weatherService.askWeatherState(town: weatherService.berlin)
        //Then
        XCTAssertTrue(weatherService.openWeather == nil)
    }
    func testGetWeatherShouldPostFailedIfIncorrectResponse() {
            //Given=
        let weatherService = WeatherService(weatherSession: URLSessionWeatherFake(data: WeatherDataResponseFake.quoteIncorrectData, response: WeatherDataResponseFake.responseIncorrect, error: nil))
    //        let berlin: [String: String] = [
    //            "q": "berlin,de",
    //            "mode": "json",
    //            "appid": "d2fc02766020f446cb8063c244166041"
    //        ]
            //When
            weatherService.askWeatherState(town: weatherService.berlin)
            //Then
            XCTAssertTrue(weatherService.openWeather == nil)
        }
}
