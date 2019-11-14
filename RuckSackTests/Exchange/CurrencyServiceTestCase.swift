//
//  CurrencyServiceTestCase.swift
//  RuckSackTests
//
//  Created by Patrick Wiley on 07.11.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import XCTest
@testable import RuckSack

class CurrencyServiceTestCase: XCTestCase,CurrencyServiceDelegate {

    var expectation = XCTestExpectation()
    func didUpdateCurrencyData(eurRate: String, usdRate: String) {
        expectation.fulfill()
    }

    func didHappenedError(error: CurrencyError) {

    }

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
//    func testRequestCurrencyData() {
//
//        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(data: CurrencyDataResponseFake.currencyCorrectData, response: CurrencyDataResponseFake.responseCorrect, error: nil))
//        expectation = expectation(description: "Wait for the info")
//        currencyService.delegate = self
//        currencyService.askCurrencyRate()
//
//        let usd = currencyService.currency?.rates!.usd
//        print(usd)
//        waitForExpectations(timeout: 3)
//        XCTAssertEqual(usd, 1.107518)
//
//    }
}
//class CurrencyServiceTestCase: XCTestCase {
//
//
////    func didUpdateCurrencyData(eurRate: String, usdRate: String) {
////        expectation.fulfill()
////    }
//
//    func didHappenedError(error: CurrencyError) {
//
//    }
//
//    func testGetCurrencyShouldPostFailedIfError() {
//        //Given=
//        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(data: nil, response: nil, error: CurrencyDataResponseFake.error ))
//
//        //When
//        let expectation = XCTestExpectation(description: "wait for queue")
//        currencyService.askCurrencyRate { (success, currency) in
//            XCTAssertFalse(success)
//            XCTAssertNil(currency)
//            expectation.fulfill()
//        }
//        //Then
//        wait(for: [expectation], timeout: 0.1)
//    }
//    func testGetCurrencyShouldPostFailedNoData() {
//        //Given=
//        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(data: nil, response: nil, error: nil))
//        //When
//        let expectation = XCTestExpectation(description: "wait for queue")
//        currencyService.askCurrencyRate { (success, currency) in
//            XCTAssertFalse(success)
//            expectation.fulfill()
//        }
//        //Then
//        wait(for: [expectation], timeout: 0.1)
//    }
//    func testGetCurrencyShouldPostFailedIfIncorrectResponse() {
//        //Given=
//        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(data: CurrencyDataResponseFake.currencyIncorrectData, response: CurrencyDataResponseFake.responseCorrect, error: nil))
//        //When
////        let expectation = XCTestExpectation(description: "wait for queue")
//        currencyService.askCurrencyRate { (success, currency) in
//            XCTAssertFalse(success)
//            XCTAssertNil(currency)
////            expectation.fulfill()
//        }
//        //Then
////        wait(for: [expectation], timeout: 0.1)
//
//    }
//
//    func testGetCurrencyShouldPostFailedIfCorrectResponse() {
//        //Given=
//        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(data: CurrencyDataResponseFake.currencyCorrectData, response: CurrencyDataResponseFake.responseIncorrect, error: nil))
//        //When
//        let expectation = XCTestExpectation(description: "wait for queue")
//        currencyService.askCurrencyRate { (success, currency) in
//            XCTAssertFalse(success)
//            XCTAssertNil(currency)
//            expectation.fulfill()
//        }
//        //Then
//        wait(for: [expectation], timeout: 0.1)
//
//    }
//    func testRequestCurrencyData() {
//
//        let currencyService = CurrencyService(currencySession: URLSessionCurrencyFake(data: CurrencyDataResponseFake.currencyCorrectData, response: CurrencyDataResponseFake.responseCorrect, error: nil))
//        let expectation = XCTestExpectation(description: "wait for queue")
//        currencyService.askCurrencyRate { (success, currency) in
//            let usd = 1.107518
//            XCTAssertTrue(success)
//            XCTAssertNotNil(currency)
//            XCTAssertEqual(usd, currency!.rates?.usd)
//            expectation.fulfill()
//        }
//        //Then
//        wait(for: [expectation], timeout: 0.1)
//    }
//}
