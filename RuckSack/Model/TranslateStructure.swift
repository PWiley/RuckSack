//
//  TranslateStructure.swift
//  RuckSack
//
//  Created by Patrick Wiley on 06.10.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation



// MARK: - Translation
struct TranslationToSend: Codable {
   let q: [String]
   let target: String
}


// MARK: - Translation
struct Translation: Decodable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Decodable {
    let translations: [TranslationElement]
}

// MARK: - TranslationElement
struct TranslationElement: Decodable {
    let translatedText: String
}

