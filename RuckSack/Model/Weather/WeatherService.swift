//
//  WeatherService.swift
//  Bundle
//
//  Created by Patrick Wiley on 27.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation


class WeatherService {
    
    private static let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?")!
    static let apiKey = "q=Berlin,us&mode=json&appid=d2fc02766020f446cb8063c244166041"
    //static let apiKey = "q=Newyorck,us&mode=json&appid=d2fc02766020f446cb8063c244166041"
    var delegate: WeatherServiceDelegate?
    //private static let weatherURL = URL(string: baseURL + apiKey)!
    private var task: URLSessionDataTask?
    //var delegate: WeatherServiceDelegate?
    
    var forecast: YahooWeather?
//    var city: City?
//    var clouds: Clouds?
//    var coord: Coord?
//    var list: List?
//    var main: MainClass?
//    var sys: Sys?
//    var weather: Weather?
//    var wind: Wind?
    
    static var berlin: [String: String] = [
        "q": "Berlin,de",
        "mode": "json",
        "appid": "d2fc02766020f446cb8063c244166041"
    ]
    static var newYork: [String: String] = [
        "q": "new York,us",
        "mode": "json",
        "appid": "d2fc02766020f446cb8063c244166041"
    ]
    
    func createRequest() -> URLRequest {
        
        var request = URLRequest(url: (WeatherService.baseURL.withQueries(WeatherService.berlin)!))
        request.httpMethod = "POST"
        return request
    }
    
    func askWeatherState(town: [String: String]) {
        
        //let request = URLRequest(url: WeatherService.weatherURL)
        let request = createRequest()
        //print(request)
        print(town.values)
        let session = URLSession(configuration: .default)
        task = session.dataTask(with: request) { data, response, error in
            //print(response)
            if error != nil {
                print("Client error!")
                print("something went wrong ", error!)
                return
            }
            guard let jsonData = data else {
                print("Error data!")
                
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            DispatchQueue.main.async {
                print(jsonData)
               
//                self.weather = try? JSONDecoder().decode(WeatherStructure.self, from: jsonData)
                self.forecast = try? JSONDecoder().decode(YahooWeather.self, from: jsonData)

                //self.weatherForecast = try? JSONDecoder().decode(WeatherForecast.self, from: jsonData)
                //print(self.weatherForecast
                self.delegate?.didUpdateWeatherData(forecast: self.forecast!)
                //print(self.forecast)

            }
            //
            
        }
//        print("hep: \(forecast?.city.name as Any)")
//        print(forecast?.city.country as Any)
//        print(forecast?.list.count)
//
//        //guard let count = forecast?.list.capacity else {return}
//        for number in 0..<40{
//            print("time\(number): \(String(describing: weather?.list[number].dtTxt))")
//            print("temp\(number): \(String(describing: weather?.list[number].main.temp))")
//        }
//
        printResult()
        //print(exchange?.cod as Any)
        task?.resume()
        
    }
    func printResult() {
        if forecast?.list != nil {
//            print("hep: \(forecast?.city.name as Any)")
//            print(forecast?.city.country as Any)
//            print(forecast?.list.count)
//
            //guard let count = forecast?.list.capacity else {return}
            for number in 0..<40{
                print("time\(number): \(String(describing: forecast?.list[number].dtTxt))")
                //print("temp\(number): \(String(describing: forecast?.list[number].main.temp))")
                print("temp\(number): \(String(describing: forecast?.list[number].main.temp))")
            }
        calculateTempMedium()
        }
    }
    
    func calculateTempMedium() {
        var temp = 0.0
        for number in 0..<8{
            temp += (forecast?.list[number].main.temp)!
        }
        print("La tmperature aujourd'hui sera de : \(temp/8)")
    }
    
}


enum NetworkError: Error {
    case clientError
    case serverError
    case jsonError
}
//
//enum WichTown {
//    case berlin
//    case newYork
//}


protocol WeatherServiceDelegate {
    func didUpdateWeatherData(forecast: YahooWeather)
}
