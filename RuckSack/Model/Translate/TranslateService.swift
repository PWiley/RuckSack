//
//  TranslateService.swift
//  Bundle
//
//  Created by Patrick Wiley on 27.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit
import Foundation

class TranslateService {
    // Get the file
    private var task: URLSessionDataTask?
    var delegate: TranslateServiceDelegate?
    private static let translateURL = URL(string: "https://translation.googleapis.com/language/translate/v2/")!
    
//    func createJson() -> String {
//        let translation = TranslationToSend(q: ["Hello world, it's time to go far away"], target: "de")
//        
//        let json = try? JSONEncoder().encode(translation)
//        let jsonString = String(data: json!, encoding: .utf8)
//        
//        print(jsonString as Any)
//        print(json as Any)
//        return jsonString!
//    }
    
    func createRequest() -> URLRequest {
        
        let query: [String: String] = [
            "key": "AIzaSyDd_8AuTs9gGs_jA233qUPv2_P69qtnW7c",
            "q": "Hello world, it's time to go far away",
            "target": "fr"
        ]
        
        var request = URLRequest(url: TranslateService.translateURL.withQueries(query)!)
        request.httpMethod = "POST"
        print(request)
        return request
    }
    func createCall() {
        
        let request = createRequest()
        
        task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("Hourra")
            if error != nil {
                print("Client error!")
                print("something went wrong ", error!)
                return
            }
            guard let jsonData = data, error == nil else { return}
            guard let response = response as? HTTPURLResponse, (200...209).contains(response.statusCode) else {return}
            DispatchQueue.main.async{
            let translate = try? JSONDecoder().decode(Translate.self, from: jsonData)
                       //let jsonAnswerDataClass = try? JSONDecoder().decode(DataClass.self , from: data)
                       //let jsonAnswerTranslationElement = try? JSONDecoder().decode(TranslationElement.self , from: data)
                       print(jsonData)
                       print(translate?.data.translations[0].translatedText as Any)
            
            }
           
        }
        task?.resume()
    }
    
}
protocol TranslateServiceDelegate{
    func didUpdateTranslateData()
}
