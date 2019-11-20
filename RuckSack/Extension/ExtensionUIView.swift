//
//  ExtensionUIView.swift
//  Bundle
//
//  Created by Patrick Wiley on 12.09.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableView: UIView {
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
    }
}

@IBDesignable
class DesignableButton: UIButton {
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
    }
}

@IBDesignable
class DesignableLabel: UILabel {
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
    }
}

@IBDesignable
class DesignableTextField: UITextField {
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
}
