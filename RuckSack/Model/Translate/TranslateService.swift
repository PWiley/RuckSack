//
//  TranslateService.swift
//  Bundle
//
//  Created by Patrick Wiley on 27.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation

class TranslateService {
    // Get the file
    private var task: URLSessionDataTask?
    var delegate: TranslateServiceDelegate?
    private static let translateURL = URL(string: "https://translation.googleapis.com/language/translate/v2/")!
    var translate: Translate?
    var sentence: String = ""
    var request: URLRequest?
    
//    static var query: [String: String] = [
//        "key": "AIzaSyAbFRlWhZO4li5HUWUSZ3V3f2n3Z8ooqKs",
//        "q": "",
//        "target": ""
//    ]
    func createRequest(sentence: String, targetLanguage: String){
        let query: [String: String] = [
            "key": "AIzaSyAbFRlWhZO4li5HUWUSZ3V3f2n3Z8ooqKs",
            "q": sentence,
            "target": targetLanguage
        ]
        request = URLRequest(url: TranslateService.translateURL.withQueries(query)!)
        print("query: \(query)")
        request?.httpMethod = "POST"
        print(request)
    }
    func checkLanguageTarget(target: String) {
          switch target{
          case "fr":
            self.delegate?.didUpdateTranslateData(translate: translate!, targetLanguage: "en")
              print("Tout est ok")
          case "en":
            self.delegate?.didUpdateTranslateData(translate: translate!, targetLanguage: "fr")
              print("All good")
          default:
            print("erreur de language")
          }
        
      }
    func createCall() {
        
        
        
        task = URLSession.shared.dataTask(with: request!) { (data, response, error) in
            
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
            DispatchQueue.main.async{
                
                self.translate = try? JSONDecoder().decode(Translate.self, from: jsonData)
                print(jsonData)
                print(self.translate?.data.translations[0].translatedText as Any)
                self.checkLanguageTarget(target: (self.translate?.data.translations[0].detectedSourceLanguage)!)
                //self.delegate?.didUpdateTranslateData(translate: self.translate!)
                
//                do {
//                    self.translate = try? JSONDecoder().decode(Translate.self, from: jsonData)
//                    print(jsonData)
//                    print(self.translate?.data.translations[0].translatedText as Any)
//                    self.delegate?.didUpdateTranslateData(translate: self.translate!)
//                } catch {
//                    print("JSON error: \(error)")
//                }
            }
        }
        task?.resume()
    }
    
  
}

protocol TranslateServiceDelegate{
    func didUpdateTranslateData(translate: Translate, targetLanguage: String)
}
