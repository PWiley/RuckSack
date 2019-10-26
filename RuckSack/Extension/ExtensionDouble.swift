//
//  ExtensionString.swift
//  RuckSack
//
//  Created by Patrick Wiley on 26.10.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation


extension Double {
    var celcius: Double {
        return self - 273.15
    }
    var roundTo: Double {
        let divisor = pow(10.0, Double(0))
        return (self * divisor).rounded() / divisor
    }
}
