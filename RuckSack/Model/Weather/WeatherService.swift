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
    //static let apiKey = "q=Newyorck,us&mode=json&appid=d2fc02766020f446cb8063c244166041"
   
    //private static let weatherURL = URL(string: baseURL + apiKey)!
    private var task: URLSessionDataTask?
    var delegate: WeatherServiceDelegate?
    var openWeather: OpenWeather?
    
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
        
        print(town.values)
        let session = URLSession(configuration: .default)
        task = session.dataTask(with: request) { data, response, error in
            print(response as Any)
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
               
               
//                self.weather = try? JSONDecoder().decode(WeatherStructure.self, from: jsonData)
                self.openWeather = try? JSONDecoder().decode(OpenWeather.self, from: jsonData)
                //self.weatherOpenWeather = try? JSONDecoder().decode(WeatherOpenWeather.self, from: jsonData)
                //print(self.openWeather!.list[0].dtTxt)
                guard let openWeatherStruct = self.openWeather else {print("Erreur")
                    return}
                self.delegate?.didUpdateWeatherData(openWeather: openWeatherStruct)
                //print(self.openWeather)

            }
        }
//        print("hep: \(openWeather?.city.name as Any)")
//        print(openWeather?.city.country as Any)
//        print(openWeather?.list.count)
//
//        //guard let count = openWeather?.list.capacity else {return}
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
        if openWeather?.list != nil {
//            print("hep: \(openWeather?.city.name as Any)")
//            print(openWeather?.city.country as Any)
//            print(openWeather?.list.count)
//
            print("count: \(openWeather!.list.count)")
            //guard let count = openWeather?.list.capacity else {return}
            for number in 0..<40{
                print("time\(number): \(String(describing: openWeather?.list[number].dt))")
                print("time\(number): \(String(describing: openWeather?.list[number].dtTxt))")
                //print("temp\(number): \(String(describing: openWeather?.list[number].main.temp))")
                print("temp\(number): \(String(describing: openWeather?.list[number].main.temp))")
                print("tempMax\(number): \(String(describing: openWeather?.list[number].main.tempMax))")
                print("tempMin\(number): \(String(describing: openWeather?.list[number].main.tempMin))")
            }
        //calculateTempMedium()
        }
    }

//    func calculateTempMedium() {
//        var temp = 0.0
//        for number in 0..<8{
//            temp += (openWeather?.list[number].main.temp)!
//        }
//        print("La tmperature aujourd'hui sera de : \(temp/8)")
//    }
//    func setStateImage(stateWeather: String) {
//        switch stateWeather {
//          case "Clear":
//            print("Type is abc")
//          case "Clouds":
//            print("Type is def")
//          default:
//            print("Type is something else")
//        }
//
//    }
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
//enum WeatherState {
//    case
//}

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
    func didUpdateWeatherData(openWeather: OpenWeather)
}
