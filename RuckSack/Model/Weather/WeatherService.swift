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
    private var task: URLSessionDataTask?
    static var sharedWeather = WeatherService()
    private init() {}
    var delegate: WeatherServiceDelegate?
    var openWeather: OpenWeather?
    
    private var weatherSession = URLSession(configuration: .default)
    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }
    var berlin: [String: String] = [
        "q": "berlin,de",
        "mode": "json",
        "appid": ""
    ]
    var newYork: [String: String] = [
        "q": "new york,us",
        "mode": "json",
        "appid": ""
    ]
    
    func createRequest(query: [String: String]) -> URLRequest {
        let queryRequest = setQueryWithApi(query: query)
        var request = URLRequest(url: (WeatherService.baseURL.withQueries(queryRequest)!))
        request.httpMethod = "POST"
        return request
    }
    
    func askWeatherState(town: [String: String]) {
        
        let request = createRequest(query: town)
        task = weatherSession.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.delegate?.didHappenedError(error: .clientError)
                }
                return
            }
            guard let jsonData = data, error == nil else {
                DispatchQueue.main.async {
                    self.delegate?.didHappenedError(error: .clientError)
                }
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                DispatchQueue.main.async {
                    self.delegate?.didHappenedError(error: .clientError)
                }
                return
            }
            DispatchQueue.main.async {
                
                self.openWeather = try? JSONDecoder().decode(OpenWeather.self, from: jsonData)
           guard let openWeather = self.openWeather else {return}
                self.delegate?.didUpdateWeatherData(openWeather: openWeather)
     
            }
            
        }
      
        task?.resume()
        
    }
    
    
    func setTime(timestamp: Double) -> Bool{
        
        var isNight: Bool?
        let date = Date(timeIntervalSince1970: timestamp)
        let hour = Calendar.current.component(.hour, from: date)
        //let min = Calendar.current.component(.minute, from: date)
//        if (hour >= 6 && min >= 00) && (hour < 18 && min < 60) {
        if (hour >= 6) && (hour < 18) {
            isNight = false
        }
//        if (hour >= 18 && min >= 00) || (hour < 6 && min <= 59){
        if (hour >= 18) || (hour < 6){
            isNight = true
        }
        return isNight!
    }
    
    func setDayStateName(indexList: Int) -> String{
        let time = openWeather!.list[indexList].dt
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " dd/MM" //Specify your format that you want
        let monthDay = dateFormatter.string(from: date)
        let weekday = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date)-1]
        let dayName = weekday + monthDay
        return dayName
    }
    
    func setQueryWithApi(query: [String: String]) -> [String: String] {
        var queryApiKey = query
        queryApiKey["appid"] = valueForAPIKey(named:"API_CLIENT_ID_WEATHER")
        return queryApiKey
    }
    
}
enum NetworkError: Error {
    case clientError
    case serverError
    case jsonError
}
protocol WeatherServiceDelegate {
    func didUpdateWeatherData(openWeather: OpenWeather)
    func didHappenedError(error: NetworkError)
}
