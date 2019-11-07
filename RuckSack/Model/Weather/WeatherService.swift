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
        "appid": "d2fc02766020f446cb8063c244166041"
    ]
    var newYork: [String: String] = [
        "q": "new york,us",
        "mode": "json",
        "appid": "d2fc02766020f446cb8063c244166041"
    ]
    
    func createRequest(query: [String: String]) -> URLRequest {
        
        var request = URLRequest(url: (WeatherService.baseURL.withQueries(query)!))
        request.httpMethod = "POST"
        return request
    }
    
    func askWeatherState(town: [String: String]) {
        
        //task?.cancel()
        let request = createRequest(query: town)
        //task?.cancel()
        task = weatherSession.dataTask(with: request) { data, response, error in
            //print(response as Any)
            if error != nil {
                DispatchQueue.main.async {
                    self.delegate?.didHappenedError(error: .clientError)
                }
//                print("Client error!")
//                print("something went wrong ", error!)
                return
            }
            guard let jsonData = data, error == nil else {
                DispatchQueue.main.async {
                    self.delegate?.didHappenedError(error: .clientError)
                }
//                print("Error data!")
                
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                DispatchQueue.main.async {
                    self.delegate?.didHappenedError(error: .clientError)
                }
                //print("Server error!")
                return
            }
            DispatchQueue.main.async {
                
                
                //self.weather = try? JSONDecoder().decode(WeatherStructure.self, from: jsonData)
                self.openWeather = try? JSONDecoder().decode(OpenWeather.self, from: jsonData)
                //self.weatherOpenWeather = try? JSONDecoder().decode(WeatherOpenWeather.self, from: jsonData)
                //print(self.openWeather!.list[0].dtTxt)
                guard let openWeather = self.openWeather else {print("Erreur")
                    return}
                self.delegate?.didUpdateWeatherData(openWeather: openWeather)
                //print(self.openWeather)
                
            }
            
        }
      
        task?.resume()
        
    }
    
    
    func setTime(timestamp: Double) -> Bool{
        
        var isNight: Bool?
        let date = Date(timeIntervalSince1970: timestamp)
        let hour = Calendar.current.component(.hour, from: date)
        let min = Calendar.current.component(.minute, from: date)
        if (hour >= 6 && min >= 00) && (hour < 18 && min < 60) {
            isNight = false
        }
        if (hour >= 18 && min >= 00) || (hour < 6 && min <= 59){
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
