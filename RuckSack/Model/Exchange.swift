//
//  ExchangeModel.swift
//  Bundle
//
//  Created by Patrick Wiley on 27.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation
import UIKit

class Exchange {
    
    var exchangeView = ExchangeViewController()
    var currencies: [Currency] = []
    
    func createCurrency() -> [Currency] {
        let euro = Currency(shortLabel: "EUR", name: "Euro", image: #imageLiteral(resourceName: "british-pound"), amount: "1000")
        let dollar = Currency(shortLabel: "USD", name: "US-Dollar", image: #imageLiteral(resourceName: "us-dollar"), amount: "1000")
         return [euro, dollar]
    }
    func askCurrencyRate() -> JSONSerialization {
        
        var json: JSONSerialization?
        let fixerURL = URL(string: "http://data.fixer.io/api/latest?access_key=512b6a9fdea5eb6241c0cda88a1079eb")!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: fixerURL) { data, response, error in
            if error != nil {
                print("Client error!")
                return
            }
            guard let data = data else {
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
            do {
                json = try (JSONSerialization.jsonObject(with: data, options: []) as? JSONSerialization)
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        return json!
    }
    
    
}

class Currency {
    
    var shortLabel: String
    var name: String
    var image: UIImage
    var amount: String
    
    init(shortLabel: String, name: String, image: UIImage, amount: String) {
        self.shortLabel = shortLabel
        self.name = name
        self.image = image
        self.amount = amount
    }
}

