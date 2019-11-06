//
//  ExtensionDouble.swift
//  RuckSack
//
//  Created by Patrick Wiley on 06.11.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    var celcius: Double {
        let tempCelcius = self - 273.15
        return tempCelcius
    }
}
