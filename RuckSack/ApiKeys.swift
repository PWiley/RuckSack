//
//  ApiKeys.swift
//  RuckSack
//
//  Created by Patrick Wiley on 08.11.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation


func valueForAPIKey(named keyname:String) -> String {
  // Credit to the original source for this technique at
  // http://blog.lazerwalker.com/blog/2014/05/14/handling-private-api-keys-in-open-source-ios-apps
    let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
  let plist = NSDictionary(contentsOfFile:filePath!)
  let value = plist?.object(forKey: keyname) as! String
  return value
}
