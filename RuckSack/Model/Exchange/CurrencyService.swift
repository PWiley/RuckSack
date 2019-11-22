//
//  CurrencyService.swift
//  Bundle
//
//  Created by Patrick Wiley on 27.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation

class CurrencyService {
    
    private static let currencyURL = URL(string: "http://data.fixer.io/api/latest?")!
    private var task: URLSessionDataTask?
    private var currencySession = URLSession(configuration: .default)
    
     // MARK: - Singleton
    
    static var sharedCurrency = CurrencyService()
    private init() {}
    
    var currency: Currency?
    var delegate: CurrencyServiceDelegate?

    init(currencySession: URLSession) {
        self.currencySession = currencySession
    }
}
extension CurrencyService {
    
    // MARK: - Public Methods
    // MARK: ** Network Calls
    
    func createRequest() -> URLRequest {
        
        let query: [String: String] = [
            "access_key": "",
            "symbols": "USD",
            "base": "EUR"
        ]
        let queryRequest = setQueryWithApiKey(query: query)
        var request = URLRequest(url: CurrencyService.currencyURL.withQueries(queryRequest)!)
        request.httpMethod = "POST"
        return request
    }
    func askCurrencyRate() {
        
        task?.cancel()
        let request = createRequest()
        task = currencySession.dataTask(with: request) { data, response, error in
            if error != nil {
                self.delegate?.didHappenedError(error: .clientError)
                return
            }
            guard let jsonData = data else {
                self.delegate?.didHappenedError(error: .clientError)
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                self.delegate?.didHappenedError(error: .clientError)
                return
            }
            DispatchQueue.main.async {
                do {
                    
                    self.currency = try JSONDecoder().decode(Currency.self, from: jsonData)
                    guard let currency = self.currency else {return}
                    self.calculateValueCurrency(currency: currency)
                    
                } catch {
                    print("JSON error: \(error)")
                }
            }
        }
        task?.resume()
    }
    // MARK: ** Handling Answers
    
    
    func calculateValueCurrency(currency: Currency) {
        // the data was received and parsed to String
        guard let euroRate = currency.rates?.usd else {return}
        let usdValue = String(format:"%.3f", 1/euroRate)
        let euroValue = String(format:"%.3f", euroRate)
        self.delegate?.didUpdateCurrencyData(eurRate: euroValue, usdRate: usdValue)
        
    }
    
    func calculateResult(amount: Double, base: String) -> Double {
        var result: Double?
        guard let rates = currency?.rates?.usd else{self.delegate?.didHappenedError(error: .clientError)
                                                    return 0 }
        if base == "EUR" {
            result = amount * rates
        } else {
            result = amount / rates
        }
        return result!
        }
    func setQueryWithApiKey(query: [String: String]) -> [String: String] {
        var queryApiKey = query
        queryApiKey["access_key"] = valueForAPIKey(named:"API_CLIENT_ID_CURRENCY")
        return queryApiKey
    }
    
}
enum CurrencyError: Error {
    case clientError
    case currencyError
    
}
 // MARK: Protocol

protocol CurrencyServiceDelegate {
    func didUpdateCurrencyData(eurRate: String, usdRate: String)
    func didHappenedError(error: CurrencyError)
}
