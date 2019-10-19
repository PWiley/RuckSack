//
//  WeatherModel.swift
//  Bundle
//
//  Created by Patrick Wiley on 27.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation


class WeatherModel {
    
    private static let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?")!
    static let apiKey = "q=Berlin,us&mode=json&appid=d2fc02766020f446cb8063c244166041"
    //static let apiKey = "q=Newyorck,us&mode=json&appid=d2fc02766020f446cb8063c244166041"
    
    //private static let weatherURL = URL(string: baseURL + apiKey)!
    private var task: URLSessionDataTask?
    //var delegate: WeatherModelDelegate?
    
    var forecast: Forecast?
    var city: City?
    var clouds: Clouds?
    var coord: Coord?
    var list: List?
    var main: MainClass?
    var sys: Sys?
    var weather: Weather?
    var wind: Wind?
    
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
        
        var request = URLRequest(url: (WeatherModel.baseURL.withQueries(WeatherModel.berlin)!))
        request.httpMethod = "POST"
        return request
    }
    
    func askWeatherState(town: [String: String]) {
        
        //let request = URLRequest(url: WeatherModel.weatherURL)
        let request = createRequest()
        print(request)
        //print(town.values)
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
               
                self.forecast = try? JSONDecoder().decode(Forecast.self, from: jsonData)
                self.city = try? JSONDecoder().decode(City.self, from: jsonData)
                self.clouds = try? JSONDecoder().decode(Clouds.self, from: jsonData)
                self.coord = try? JSONDecoder().decode(Coord.self, from: jsonData)
                self.list = try? JSONDecoder().decode(List.self, from: jsonData)
                self.main = try? JSONDecoder().decode(MainClass.self, from: jsonData)
                self.sys = try? JSONDecoder().decode(Sys.self, from: jsonData)
                self.weather = try? JSONDecoder().decode(Weather.self, from: jsonData)
                self.wind = try? JSONDecoder().decode(Wind.self, from: jsonData)
                
            }
            //
            
        }
        print("hep: \(forecast?.city.name as Any)")
        print(forecast?.city.country as Any)
        print(list?.main.temp as Any)
        print(main?.temp as Any)
        print(main?.tempMax as Any)
        print(main?.tempMin as Any)
        
        //print(exchange?.cod as Any)
        task?.resume()
        
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


protocol WeatherModelDelegate {
    func didUpdateWeatherData()
}
