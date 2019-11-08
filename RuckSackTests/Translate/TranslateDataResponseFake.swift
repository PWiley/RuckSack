//
//  TranslateDataResponseFake.swift
//  RuckSackTests
//
//  Created by Patrick Wiley on 07.11.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation


class TranslateDataResponseFake {

static var translateCorrectData: Data? {
    let bundle = Bundle(for: TranslateDataResponseFake.self)
    let url = bundle.url(forResource: "Translate", withExtension: "json")!
    return try! Data(contentsOf: url)
}

static let translateIncorrectData = "erreurData".data(using: .utf8)!

// MARK: - Response
static let responseCorrect = HTTPURLResponse(
    url: URL(string: "https://deustcheKapital.de")!,
    statusCode: 200, httpVersion: nil, headerFields: [:])!

static let responseIncorrect = HTTPURLResponse(
    url: URL(string: "https://deustcheKapital.de")!,
    statusCode: 500, httpVersion: nil, headerFields: [:])!


// MARK: - Error
class QuoteError: Error {}
static let error = QuoteError()
}
