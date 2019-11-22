//
//  CurrencyServiceTestCase.swift
//  RuckSackTests
//
//  Created by Patrick Wiley on 07.11.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import XCTest
@testable import RuckSack

class CurrencyServiceTestCase: XCTestCase {
    
    
    func testGetCurrencyShouldPostFailedIfError() {
        
        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(
            data: nil,
            response: nil,
            error: CurrencyDataResponseFake.error ))
        
        currencyService.askCurrencyRate()
        XCTAssertTrue(currencyService.currency?.rates?.usd == nil)
    }
    func testGetCurrencyShouldPostFailedNoData() {
        
        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(
            data: nil,
            response: nil,
            error: nil))
        
        currencyService.askCurrencyRate()
        XCTAssertTrue(currencyService.currency?.rates?.usd == nil)
    }
    func testGetCurrencyShouldPostFailedIfIncorrectResponse() {
        
        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(
            data: CurrencyDataResponseFake.currencyIncorrectData,
            response: CurrencyDataResponseFake.responseCorrect,
            error: nil))
        
        currencyService.askCurrencyRate()
        XCTAssertTrue((currencyService.currency?.rates?.usd == nil))
        
    }
    
    func testGetCurrencyShouldPostFailedIfCorrectResponse() {
        
        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(
            data: CurrencyDataResponseFake.currencyCorrectData,
            response: CurrencyDataResponseFake.responseIncorrect,
            error: nil))
        currencyService.askCurrencyRate()
        XCTAssertTrue((currencyService.currency?.rates?.usd == nil))
        
    }
    func testCalculateConversion() {
        
        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(
            data: CurrencyDataResponseFake.currencyCorrectData,
            response: CurrencyDataResponseFake.responseCorrect,
            error: nil))
        
        let Amount = 1.0
        let resultEur = 1.107518
        let resultUsd = 1/1.107518
        let baseEur = "EUR"
        let baseUsd = "USD"
        let expectation = XCTestExpectation(description: "Wait for info")
        let consumer = CurrencyConsumerFake()
        currencyService.delegate = consumer
        consumer.didRetrieveData = {(eurRate, usdRate) in
            let expectedUsd = currencyService.calculateResult(amount: Amount,
                                                              base: baseEur)
            XCTAssertEqual(resultEur, expectedUsd)
            let expectedEur = currencyService.calculateResult(amount: Amount,
                                                              base: baseUsd)
            XCTAssertEqual(resultUsd, expectedEur)
            expectation.fulfill()
        }
        currencyService.askCurrencyRate()
        wait(for: [expectation], timeout: 3.0)
        
    }
    func testGetCurrencyShouldPostSuccessIfNoErrorCorrectData() {
        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(
            data: CurrencyDataResponseFake.currencyCorrectData,
            response: CurrencyDataResponseFake.responseCorrect,
            error: nil))
        let eurExpected = String(format:"%.3f", 1.107518)
        let usdExpected = String(format:"%.3f", 1/1.107518)
        let expectation = XCTestExpectation(description: "Wait for info")
        let consumer = CurrencyConsumerFake()
        currencyService.delegate = consumer
        consumer.didRetrieveData = {(eurRate, usdRate) in
            XCTAssertEqual(eurRate, eurExpected)
            
            XCTAssertEqual(usdRate, usdExpected)
            expectation.fulfill()
            
        }
        currencyService.askCurrencyRate()
        wait(for: [expectation], timeout: 3.0)
    }
    
    
}
class CurrencyConsumerFake: CurrencyServiceDelegate {
    
    var didRetrieveData: ((String, String) -> Void)?
    func didUpdateCurrencyData(eurRate: String, usdRate: String) {
        didRetrieveData!(eurRate, usdRate)
    }
    
    func didHappenedError(error: CurrencyError) {
        
    }
    
    
}
