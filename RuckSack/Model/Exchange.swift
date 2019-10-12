//
//  ExchangeModel.swift
//  Bundle
//
//  Created by Patrick Wiley on 27.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation
import UIKit

class CurrencyModel {
    
    weak var delegate: CurrencyModelDelegate?
    
    private static let currencyURL = URL(string: "https://data.fixer.io/api/latest?")!
    private var task: URLSessionDataTask?
    var currency: Currency?
    
//private static let urlString = "http://data.fixer.io/api/latest?"
    func createRequest() -> URLRequest {

        
        //let body = "access_key=512b6a9fdea5eb6241c0cda88a1079eb&base=EUR&symbols=USD"
        
        let query = ["access_key": "512b6a9fdea5eb6241c0cda88a1079eb", "base": "EUR", "symbols": "USD"]
        
        var request = URLRequest(url: CurrencyModel.currencyURL.withQueries(query)!)
        request.httpMethod = "GET"
        
        //request.httpBody = body.data(using: .utf8)
//        print(request.httpBody as Any)
//        print(request)
        return request
    }
    
    func askCurrencyRate(){
        
        
        //guard let fixerURL = URL(string: CurrencyModel.urlString) else { return }
        let request = createRequest()
        let session = URLSession(configuration: .default)
        task = session.dataTask(with: request) { data, response, error in
            guard let jsonData = data, error == nil else {
                print("Client error!", error)
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
            print(jsonData)
            
//            self.currency = try? JSONDecoder().decode(Currency.self, from: jsonData)
//            print("Ouhra")
//            self.requestData(currency: self.currency!)
            do {
                self.currency = try? JSONDecoder().decode(Currency.self, from: jsonData)
                print("Ouhra")
                self.requestData(currency: self.currency!)

            } catch {
                print("JSON error")
            }
           
        }
        task?.resume()
    }
   
    
    func requestData(currency: Currency) {
        // the data was received and parsed to String
        
        self.delegate?.didRecieveDataUpdate(data: currency)
    }

}


protocol CurrencyModelDelegate: class {
func didRecieveDataUpdate(data: Currency)
}
