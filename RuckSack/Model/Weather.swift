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
    var exchange: Exchange?
    var list: List?
    var main: MainClass?
    
    
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
    
    func createRequest(query: [String: String]) -> URLRequest {
        
        var request = URLRequest(url: (WeatherModel.baseURL.withQueries(query)!))
        request.httpMethod = "POST"
        return request
    }
    
    func askWeatherState(town: [String: String]) {
            
            //let request = URLRequest(url: WeatherModel.weatherURL)
            let request = createRequest(query: town)
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
                print(jsonData)
//                do {
//                    
//                    self.exchange = try? JSONDecoder().decode(Exchange.self, from: jsonData)
//                    self.list = try? JSONDecoder().decode(List.self, from: jsonData)
//                    self.main = try? JSONDecoder().decode(MainClass.self, from: jsonData)
//                    print("Ouhra")
//                
//                } catch {
//                    
//                    print("JSON error")
//                }
               
            }
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
