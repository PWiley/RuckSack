//
//  ExtensionViewController.swift
//  RuckSack
//
//  Created by Patrick Wiley on 03.11.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func alert(title: String, message: String, titleAction: String, actionStyle: UIAlertAction.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: titleAction, style: actionStyle, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
