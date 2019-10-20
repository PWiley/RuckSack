//
//  TranslateModel.swift
//  Bundle
//
//  Created by Patrick Wiley on 27.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit
import Foundation

class TranslateModel {
    // Get the file
    private var task: URLSessionDataTask?
    var delegate: TranslateModelDelegate?
    private static let translateURL = URL(string: "https://translation.googleapis.com/language/translate/v2/")!
    
    func createJson() -> Data {
        let translation = TranslationToSend(q: ["Hello world, it's time to go far away"], target: "de")
        
        let json = try? JSONEncoder().encode(translation)
        let jsonString = String(data: json!, encoding: .utf8)
        
        print(jsonString as Any)
        print(json as Any)
        return json!
    }
    
    func createRequest() -> URLRequest {
        
        let query: [String: String] = [
            "key": "AIzaSyDd_8AuTs9gGs_jA233qUPv2_P69qtnW7c"
        ]
        
        var request = URLRequest(url: TranslateModel.translateURL.withQueries(query)!)
        request.httpMethod = "POST"
        print(request)
        return request
    }
    func createCall(jsonData: Data ) {
        
        let request = createRequest()
        
        task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("Hourra")
            guard let data = data, error == nil else { return}
            let jsonAnswerTranslation = try? JSONDecoder().decode(Translation.self , from: data)
            let jsonAnswerDataClass = try? JSONDecoder().decode(DataClass.self , from: data)
            let jsonAnswerTranslationElement = try? JSONDecoder().decode(TranslationElement.self , from: data)
        }
        task?.resume()
    }
    
}
protocol TranslateModelDelegate{
    func didUpdateTranslateData()
}
