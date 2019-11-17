//
//  TranslateService.swift
//  Bundle
//
//  Created by Patrick Wiley on 27.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation

class TranslateService {
    
    private static let translateURL = URL(string: "https://translation.googleapis.com/language/translate/v2/")!
    private var task: URLSessionDataTask?
    private var translateSession = URLSession(configuration: .default)
    
    // MARK: - Singleton
    
    static var sharedTranslate = TranslateService()
    private init() {}
    var delegate: TranslateServiceDelegate?
    var translate: Translate?
    init(translateSession: URLSession) {
        self.translateSession = translateSession
    }
    
    
    
    var sentence: String = ""
    var targetLanguage: String = ""
    var request: URLRequest?
}
extension TranslateService {
    // MARK: - Public Methods
    // MARK: ** Network Calls
    
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
    // MARK: ** Handling Answers
    
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

    // MARK: Protocol

protocol TranslateServiceDelegate{
    func didUpdateTranslateData(translate: Translate, targetLanguage: String)
    func didHappenedError(error: TranslationError)
}

