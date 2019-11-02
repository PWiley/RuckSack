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
    var translate: Translate?
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
    static var query: [String: String] = [
               "key": "AIzaSyAbFRlWhZO4li5HUWUSZ3V3f2n3Z8ooqKs",
               "q": getTextToTranslate(),
               "target": "fr"
           ]
    func createRequest(query: [String: String]) -> URLRequest {
        var request = URLRequest(url: TranslateService.translateURL.withQueries(query)!)
        print("query: \(query)")
        request.httpMethod = "POST"
        print(request)
        return request
    }
    func createCall() {
        
        let request = createRequest(query: TranslateService.query)
        
        task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print("Client error!")
                print("something went wrong ", error!)
                return
            }
            guard let jsonData = data, error == nil else { return}
            guard let response = response as? HTTPURLResponse, (200...209).contains(response.statusCode) else {return}
            DispatchQueue.main.async{
                self.translate = try? JSONDecoder().decode(Translate.self, from: jsonData)
                       print(jsonData)
                print(self.translate?.data.translations[0].translatedText as Any)
            
            }
            print(self.translate?.data.translations[0].translatedText as Any)

        }
        task?.resume()
    }
    
    static func getTextToTranslate() -> String{
        var sentence = "Hello"
        return sentence
    }
    
}
protocol TranslateServiceDelegate{
    func didUpdateTranslateData()
}
