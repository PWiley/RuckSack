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
        translateService.createRequest(sentence: "Bonjour", targetLanguage: "en")
        translateService.createCall()
        //Then
        XCTAssertTrue(translateService.sentence == "")
    }

}
