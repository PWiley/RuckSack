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
        let translateService = TranslateService(translateSession: URLSessionTranslateFake(data: TranslateDataResponseFake.translateCorrectData,
                                                                                                 response: TranslateDataResponseFake.responseCorrect,
                                                                                                error: nil))
        
        let controllerFake = ControllerFake()
        translateService.delegate = controllerFake
        let expectedTranslateText = "Bonjour"

        let expectation = XCTestExpectation(description: "...")
        translateService.createRequest(sentence: "Hello", targetLanguage: "fr")
        translateService.createCall()
        controllerFake.didRetrieveTranslate = { (translate, target) in
            XCTAssertEqual(translateService.translate?.data.translations[0].translatedText, expectedTranslateText)
            expectation.fulfill()
        }
        translateService.createRequest(sentence: "Hello", targetLanguage: "fr")
        translateService.createCall()
        
        wait(for: [expectation], timeout: 3.0)
    }
}
class ControllerFake: TranslateServiceDelegate {
      
      var didRetrieveTranslate: ((Translate, String) -> Void)?
      func didUpdateTranslateData(translate: Translate, targetLanguage: String) {
          didRetrieveTranslate!(translate, targetLanguage)
      }
      
      func didHappenedError(error: TranslationError) {
          
      }
      
      
  }
