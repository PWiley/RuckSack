//
//  ExchangeStructure.swift
//  RuckSack
//
//  Created by Patrick Wiley on 06.10.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation


// MARK: - Currency
struct Currency: Decodable {
    let success: Bool
    let timestamp: Int?
    let base, date: String?
    let rates: Rates?
}

// MARK: - Rates
struct Rates: Decodable {
    let usd: Double

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}
