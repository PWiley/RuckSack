//
//  TranslateStructure.swift
//  RuckSack
//
//  Created by Patrick Wiley on 06.10.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation

import Foundation

// MARK: - Translate
struct Translate: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Codable {
    let translatedText, detectedSourceLanguage: String
}
