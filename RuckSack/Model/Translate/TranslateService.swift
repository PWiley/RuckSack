//
//  TranslateService.swift
//  Bundle
//
//  Created by Patrick Wiley on 27.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation

class TranslateService {
    
    private var task: URLSessionDataTask?
    var delegate: TranslateServiceDelegate?
    static var sharedTranslate = TranslateService()
    private init() {}
    private static let translateURL = URL(string: "https://translation.googleapis.com/language/translate/v2/")!
    var translate: Translate?
    var sentence: String = ""
    var targetLanguage: String = ""
    var request: URLRequest?
    
    private var translateSession = URLSession(configuration: .default)
    
    init(translateSession: URLSession) {
        self.translateSession = translateSession
    }

    func createRequest(sentence: String, targetLanguage: String) {
        let query: [String: String] = [
            "key": "AIzaSyAbFRlWhZO4li5HUWUSZ3V3f2n3Z8ooqKs",
            "q": sentence,
            "target": targetLanguage
        ]
        request = URLRequest(url: TranslateService.translateURL.withQueries(query)!)
        request?.httpMethod = "POST"
    
    }
    func checkLanguageTarget(target: String) {
          switch target{
          case "fr":
            self.delegate?.didUpdateTranslateData(translate: translate!, targetLanguage: "en")
          case "en":
            self.delegate?.didUpdateTranslateData(translate: translate!, targetLanguage: "fr")
          default:
            self.delegate?.didHappenedError(error: .wrongLanguage)
            
          }
        
      }
    func createCall() {
        task?.cancel()
        task = translateSession.dataTask(with: request!) { (data, response, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    self.delegate?.didHappenedError(error: .clientError)
                }
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
                self.checkLanguageTarget(target: (self.translate?.data.translations[0].detectedSourceLanguage)!)
            }
        }
        task?.resume()
    }
}
enum TranslationError: Error {
    case clientError
    case wrongLanguage
}

protocol TranslateServiceDelegate{
    func didUpdateTranslateData(translate: Translate, targetLanguage: String)
    func didHappenedError(error: TranslationError)
}
