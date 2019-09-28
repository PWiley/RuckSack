//
//  WeatherModel.swift
//  Bundle
//
//  Created by Patrick Wiley on 27.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation

class Weather {
    
    func askWeatherState() -> JSONSerialization {
        
//        var json: JSONSerialization?
        let WeatherURL = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=Paris,us&mode=json&appid=d2fc02766020f446cb8063c244166041")!
        //let session = URLSession(configuration: .default)
        //var request = URLRequest(url: fixerURL)
        //request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: WeatherURL) { data, response, error in
            if error != nil {
                print("Client error!")
                return
            }
            guard let data = data else {
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

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
        return json

    }
    

}
