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
            "key": "",
            "q": sentence,
            "target": targetLanguage
        ]
        let queryRequest = setQueryWithApi(query: query)
        print(queryRequest)
        request = URLRequest(url: TranslateService.translateURL.withQueries(queryRequest)!)
        request?.httpMethod = "POST"
        
    
    }
    func checkLanguageTarget(target: String) {
        guard let translate = translate else{return}
          switch target{
          case "fr":
            self.delegate?.didUpdateTranslateData(translate: translate, targetLanguage: "en")
          case "en":
            self.delegate?.didUpdateTranslateData(translate: translate, targetLanguage: "fr")
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
                return
            }
            guard let jsonData = data else {
                self.delegate?.didHappenedError(error: .jsonError)
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                self.delegate?.didHappenedError(error: .responseError)
                return
            }
            
            DispatchQueue.main.async{
                
                self.translate = try? JSONDecoder().decode(Translate.self, from: jsonData)
                guard let target = self.translate?.data.translations[0].detectedSourceLanguage else{return}
                self.checkLanguageTarget(target: target)
            }
        }
        task?.resume()
    }
    func setQueryWithApi(query: [String: String]) -> [String: String] {
        var queryApiKey = query
        queryApiKey["key"] = valueForAPIKey(named:"API_CLIENT_ID_TRANSLATE")
        return queryApiKey
    }
}
enum TranslationError: Error {
    case clientError
    case jsonError
    case responseError
    case wrongLanguage
    
}

protocol TranslateServiceDelegate{
    func didUpdateTranslateData(translate: Translate, targetLanguage: String)
    func didHappenedError(error: TranslationError)
}
