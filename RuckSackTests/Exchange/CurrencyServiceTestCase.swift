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
        //Given=
        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(data: nil, response: nil, error: CurrencyDataResponseFake.error ))
        
        //When
        
        currencyService.askCurrencyRate()
        //Then
        XCTAssertTrue(currencyService.currency?.rates?.usd == nil)
    }
    func testGetCurrencyShouldPostFailedNoData() {
        //Given=
        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(data: nil, response: nil, error: nil))
        //When
        currencyService.askCurrencyRate()
        //Then
        XCTAssertTrue(currencyService.currency?.rates?.usd == nil)
    }
    func testGetCurrencyShouldPostFailedIfIncorrectResponse() {
        //Given=
        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(data: CurrencyDataResponseFake.currencyIncorrectData, response: CurrencyDataResponseFake.responseCorrect, error: nil))
        //When
        currencyService.askCurrencyRate()
        
        //Then
        XCTAssertTrue((currencyService.currency?.rates?.usd == nil))
        
    }
    
    func testGetCurrencyShouldPostFailedIfCorrectResponse() {
        //Given=
        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(data: CurrencyDataResponseFake.currencyCorrectData, response: CurrencyDataResponseFake.responseIncorrect, error: nil))
        //When
        currencyService.askCurrencyRate()
        
        //Then
        XCTAssertTrue((currencyService.currency?.rates?.usd == nil))
        
    }
    
}
