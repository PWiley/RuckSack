//
//  WeatherStructure.swift
//  RuckSack
//
//  Created by Patrick Wiley on 06.10.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let yahooWeather = try? newJSONDecoder().decode(YahooWeather.self, from: jsonData)

import Foundation


// MARK: - OpenWeather
struct OpenWeather: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let rain: Rain?
    let sys: Sys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, rain, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: MainEnum
    let weatherDescription: Description
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum Icon: String, Codable {
    case the01D = "01d"
    case the02D = "02d"
    case the03D = "03d"
    case the04D = "04d"
    case the10D = "10d"
    case the11D = "11d"
    case the13D = "13d"
    case the01N = "01n"
    case the02N = "02n"
    case the03N = "03n"
    case the04N = "04n"
    case the10N = "10n"
    case the50D = "50d"
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case thunderstorm = "Thunderstorm"
    case drizzle = "Drizzle"
    case snow = "Snow"
    case mist = "Mist"
    case smoke = "Smoke"
    case haze = "Haze"
    case dust = "sand/ dust whirls"
    case fog = "fog"
    case sand = "sand"
    case ash = "volcanic ash"
    case squall = "squalls"
    case tornado = "tornado"
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case lightRain = "light rain"
    case moderateRain = "moderate rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
    case heavyIntensityRain = "heavy intensity rain"
    case fewClouds = "few clouds"
    case mist = "mist"
    case thunderstorm = "thunderstorm"
    case showerRain = "shower rain"
    case lightSnow = "light snow"
    
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}
