//
//  DayWeatherState.swift
//  stackview test
//
//  Created by Patrick Wiley on 29.10.19.
//  Copyright © 2019 PWiley. All rights reserved.
//

import UIKit

class DayWeatherState: UIView {

    @IBOutlet var dayWeatherState: UIView!
    
    @IBOutlet weak var dayName: UILabel!
    @IBOutlet weak var imageState: UIImageView!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        Bundle.main.loadNibNamed("DayWeatherState", owner: self, options: nil)
        addSubview(dayWeatherState)
        dayWeatherState.frame = self.bounds
        dayWeatherState.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

