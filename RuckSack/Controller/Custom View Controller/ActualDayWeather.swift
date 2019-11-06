//
//  ActualDayWeather.swift
//  RuckSack
//
//  Created by Patrick Wiley on 01.11.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit


class ActualDayWeather: UIView {
    
    @IBOutlet var actualDayWeather: UIView!
    @IBOutlet weak var imageActualWeather: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var tempActual: UILabel!
    @IBOutlet weak var humidyAmount: UILabel!
   
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
        Bundle.main.loadNibNamed("ActualDayWeather", owner: self, options: nil)
        addSubview(actualDayWeather)
        actualDayWeather.frame = self.bounds
        actualDayWeather.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
