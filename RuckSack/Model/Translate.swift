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
    var delegate: TranslateModelDelegate?
    private let translateURL = URL(string: "https://translation.googleapis.com/language/translate/v2/&key=AIzaSyDd_8AuTs9gGs_jA233qUPv2_P69qtnW7c")!
    
    func createJson() -> Data {
        let translation = TranslationToSend(q: ["Hello world, it's time to go far away"], target: "de")
        
        let json = try? JSONEncoder().encode(translation)
        let jsonString = String(data: json!, encoding: .utf8)
        
        print(jsonString)
        print(json)
        return json!
    }
    func createCall(jsonData: Data ) {
        
        var request = URLRequest(url: translateURL)
        request.httpMethod = "POST"
        request.httpBody = createJson()
        
        
        //let session = URLSession(configuration: .default)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("Hourra")
            guard let data = data, error == nil else { return}
            let jsonAnswerTranslation = try? JSONDecoder().decode(Translation.self , from: data)
            let jsonAnswerDataClass = try? JSONDecoder().decode(DataClass.self , from: data)
            let jsonAnswerTranslationElement = try? JSONDecoder().decode(TranslationElement.self , from: data)
        }.resume()
    }
    
    
    
    
    
    
}
protocol TranslateModelDelegate{
    func didUpdateTranslateData()
}
