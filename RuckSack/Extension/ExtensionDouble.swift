//
//  ExtensionDouble.swift
//  RuckSack
//
//  Created by Patrick Wiley on 06.11.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation

extension Double {
    
        var celcius: Double {
        let tempCelcius = self - 273.15
        return tempCelcius
    }
}
