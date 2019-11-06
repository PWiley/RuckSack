//
//  ExtensionString.swift
//  RuckSack
//
//  Created by Patrick Wiley on 06.11.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation


extension String {
   var trimmed: String {
           return self.starts(with: ".") ? "0\(self)" : self
       }
}
