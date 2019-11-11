//
//  TranslateServiceTestCase.swift
//  RuckSackTests
//
//  Created by Patrick Wiley on 07.11.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import XCTest
@testable import RuckSack

class TranslateServiceTestCase: XCTestCase, TranslateServiceDelegate {
    
    var expectation: XCTestExpectation!
    func didUpdateTranslateData(translate: Translate, targetLanguage: String) {
        expectation.fulfill()
    }
    
    func didHappenedError(error: TranslationError) {
        
    }
    
    func testGetTranslateShouldPostFailedIfError() {
        //Given=
        let translateService = TranslateService(translateSession: URLSessionTranslateFake(data: nil, response: nil, error: TranslateDataResponseFake.error ))
        
        //When
        translateService.createRequest(sentence: "Hello", targetLanguage: "fr")
        translateService.createCall()
        //Then
        XCTAssertTrue(translateService.sentence == "")
    }
    func testGetTranslateShouldPostFailedNoData() {
        //Given=
        let translateService = TranslateService(translateSession: URLSessionTranslateFake(data: nil, response: nil, error: nil))
        //When
        translateService.createRequest(sentence: "Hello", targetLanguage: "fr")
        translateService.createCall()
        //Then
        XCTAssertTrue(translateService.sentence == "")
    }
    func testGetTranslateShouldPostFailedIfIncorrectResponse() {
        //Given=
        let translateService = TranslateService(translateSession: URLSessionTranslateFake(data: TranslateDataResponseFake.translateCorrectData, response: TranslateDataResponseFake.responseIncorrect, error: nil))
        //When
        translateService.createRequest(sentence: "Hello", targetLanguage: "fr")
        translateService.createCall()
        //Then
        XCTAssertTrue(translateService.sentence == "")
    }
    func testGetTranslateShouldPostFailedIncorrectData() {
        //Given=
        let translateService = TranslateService(translateSession: URLSessionTranslateFake(data:TranslateDataResponseFake.translateIncorrectData,
                                                                                          response: TranslateDataResponseFake.responseCorrect, error: nil))
        //When
        translateService.createRequest(sentence: "Hello", targetLanguage: "fr")
        translateService.createCall()
        //Then
        XCTAssertTrue(translateService.sentence == "")
    }
    func testGetTranslateShouldPostSuccessIfNoErrorCorrectData() {
        //Given=
        let translateService = TranslateService(translateSession: URLSessionTranslateFake(data: TranslateDataResponseFake.translateCorrectData,
                                                                                          response: TranslateDataResponseFake.responseCorrect,
                                                                                          error: nil))
        //When
        let target = "fr"
        expectation = expectation(description: "Wait for info")
        translateService.delegate = self
        translateService.createRequest(sentence: "Hello", targetLanguage: "fr")
        translateService.createCall()
        waitForExpectations(timeout:0.5)
        translateService.checkLanguageTarget(target:target)
        
        
        XCTAssertEqual("Bonjour", translateService.translate?.data.translations[0].translatedText)
        
    }
    
}
