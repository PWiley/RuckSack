//
//  ExchangeModel.swift
//  Bundle
//
//  Created by Patrick Wiley on 27.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation
//import UIKit

class CurrencyModel {
    
    private static let currencyURL = URL(string: "http://data.fixer.io/api/latest?")!
    private var task: URLSessionDataTask?
    var currency: Currency?
    var delegate: CurrencyModelDelegate?
    
    var amountOrigin: String?
    var amountDestination: String?
    
    var exchangeView: ExchangeViewController?
    
    func createRequest() -> URLRequest {
        
        let query: [String: String] = [
            "access_key": "512b6a9fdea5eb6241c0cda88a1079eb",
            "symbols": "USD",
            "base": "EUR"
        ]
        
        var request = URLRequest(url: CurrencyModel.currencyURL.withQueries(query)!)
        request.httpMethod = "POST"
        print(request)
        return request
    }
    
    func askCurrencyRate(){
        
        task?.cancel()
        let request = createRequest()
        let session = URLSession(configuration: .default)
        task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Client error!")
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
            DispatchQueue.main.async {
                do {
                    
                    self.currency = try JSONDecoder().decode(Currency.self, from: jsonData)
                    //print("Ouhra: currency = \(self.currency?.rates?.usd)")
                    //self.requestData(currency: self.currency!)
                    
                } catch {
                    print("JSON error: \(error)")
                }
            }
        }
        task?.resume()
    }
    
    
//    func requestData(currency: Currency) {
//        // the data was received and parsed to String
//        self.delegate?.didUpdateCurrencyData(data: currency)
//        
//    }
    
    func calculateConversion(amount: Double){
//            print("le montant : \(amount)")
//            print(currency?.rates?.usd)
            guard let rates = currency?.rates?.usd else {return}
            let result = amount * rates
            print("Le result est : \(result)")
        }    
}

protocol CurrencyModelDelegate {
    func didUpdateCurrencyData(data: Currency)
}
