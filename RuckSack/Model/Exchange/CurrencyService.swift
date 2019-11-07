//
//  CurrencyService.swift
//  Bundle
//
//  Created by Patrick Wiley on 27.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation
//import UIKit

class CurrencyService {
    
    private static let currencyURL = URL(string: "http://data.fixer.io/api/latest?")!

    private var task: URLSessionDataTask?
    static var sharedCurrency = CurrencyService()
    private init() {}
    var currency: Currency?
    var delegate: CurrencyServiceDelegate?
//    var result: Double?
    
    private var currencySession = URLSession(configuration: .default)
    
    init(currencySession: URLSession) {
        self.currencySession = currencySession
    }
    
    func createRequest() -> URLRequest {
        
        let query: [String: String] = [
            "access_key": "512b6a9fdea5eb6241c0cda88a1079eb",
            "symbols": "USD",
            "base": "EUR"
        ]
        
        var request = URLRequest(url: CurrencyService.currencyURL.withQueries(query)!)
        request.httpMethod = "POST"
        print(request)
        return request
    }
    
    func askCurrencyRate(){
        
        task?.cancel()
        let request = createRequest()
        //var currency: Currency?
        task = currencySession.dataTask(with: request) { data, response, error in
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
                    self.requestData(currency: self.currency!)
                    
                } catch {
                    print("JSON error: \(error)")
                }
            }
        }
        task?.resume()
    }
    
    
    func requestData(currency: Currency) {
        // the data was received and parsed to String
        guard let euroRate = currency.rates?.usd else {return}
        let usdValue = String(format:"%.3f", 1/euroRate)
        let euroValue = String(format:"%.3f", euroRate)
        
        self.delegate?.didUpdateCurrencyData(eurRate: euroValue, usdRate: usdValue)
        
    }
    
    func calculateConversion(amount: Double, base: String) -> Double{
//            print("le montant : \(amount)")
//            print(currency?.rates?.usd
        var result: Double?
        guard let rates = currency?.rates?.usd else{return 0.0}
        if base == "EUR" {
        result = amount * rates
        } else {
        result = amount / rates
        }
        //print("Le result est : \(result)")
        return result!
        }
    
}
enum CurrencyError: Error {
    case clientError
    case currencyError
    
}


protocol CurrencyServiceDelegate {
    func didUpdateCurrencyData(eurRate: String, usdRate: String)
    func didHappenedError(error: CurrencyError)
}
