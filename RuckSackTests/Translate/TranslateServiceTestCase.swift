//
//  TranslateServiceTestCase.swift
//  RuckSackTests
//
//  Created by Patrick Wiley on 07.11.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import XCTest
@testable import RuckSack

class TranslateServiceTestCase: XCTestCase {
    
    func testGetTranslateShouldPostFailedIfError() {
        
        let translateService = TranslateService(translateSession: URLSessionTranslateFake(
            data: nil,
            response: nil,
            error: TranslateDataResponseFake.error ))
        translateService.createRequest(sentence: "Hello", targetLanguage: "fr")
        translateService.askTranslation()
        XCTAssertTrue(translateService.sentence == "")
    }
    func testGetTranslateShouldPostFailedNoData() {
        
        let translateService = TranslateService(translateSession: URLSessionTranslateFake(
            data: nil,
            response: nil,
            error: nil))
        translateService.createRequest(sentence: "Hello", targetLanguage: "fr")
        translateService.askTranslation()
        XCTAssertTrue(translateService.sentence == "")
    }
    func testGetTranslateShouldPostFailedIfIncorrectResponse() {
        
        let translateService = TranslateService(translateSession: URLSessionTranslateFake(
            data: TranslateDataResponseFake.translateCorrectData,
            response: TranslateDataResponseFake.responseIncorrect,
            error: nil))
        translateService.createRequest(sentence: "Hello", targetLanguage: "fr")
        translateService.askTranslation()
        XCTAssertTrue(translateService.sentence == "")
    }
    func testGetTranslateShouldPostFailedIncorrectData() {
        
        let translateService = TranslateService(translateSession: URLSessionTranslateFake(
            data:TranslateDataResponseFake.translateIncorrectData,
            response: TranslateDataResponseFake.responseCorrect,
            error: nil))
        
        translateService.createRequest(sentence: "Hello", targetLanguage: "fr")
        translateService.askTranslation()
        XCTAssertTrue(translateService.sentence == "")
    }
    
    func testGetTranslateShouldPostSuccessIfNoErrorCorrectData() {
        let translateService = TranslateService(translateSession: URLSessionTranslateFake(
            data: TranslateDataResponseFake.translateCorrectData,
            response: TranslateDataResponseFake.responseCorrect,
            error: nil))
        
        let consumer = TranslateConsumerFake()
        translateService.delegate = consumer
        let expectedTranslateText = "Bonjour"
        
        let expectation = XCTestExpectation(description: "Wait for info")
        
        consumer.didRetrieveTranslate = { (translate, target) in
            XCTAssertEqual(translateService.translate?.data.translations[0].translatedText,
                           expectedTranslateText)
            expectation.fulfill()
        }
        translateService.createRequest(sentence: "Hello",
                                       targetLanguage: "fr")
        translateService.askTranslation()
        
        wait(for: [expectation], timeout: 3.0)
        
    }
}
class TranslateConsumerFake: TranslateServiceDelegate {
    
    var didRetrieveTranslate: ((Translate, String) -> Void)?
    func didUpdateTranslateData(translate: Translate, targetLanguage: String) {
        didRetrieveTranslate!(translate, targetLanguage)
    }
    
    func didHappenedError(error: TranslationError) {
        
    }
    
    
}
