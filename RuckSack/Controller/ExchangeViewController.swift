
//  ExchangeViewController.swift
//  Bundle
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    private let currencyModel = CurrencyModel()
    
    @IBOutlet var exchangeViewController: UIView!
    
    @IBOutlet weak var flagCurrencyOrigin: UIImageView!
    @IBOutlet weak var shortLabelOrigin: UILabel!
    @IBOutlet weak var labelOrigin: UILabel!
    @IBOutlet weak var amountOrigin: UITextField!
    
    @IBOutlet weak var flagCurrencyDestination: UIImageView!
    @IBOutlet weak var shortLabelDestination: UILabel!
    @IBOutlet weak var labelDestination: UILabel!
    @IBOutlet weak var amountDestination: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // exchange.currencies = exchange.createCurrency()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background_Exchange")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        exchangeViewController.insertSubview(backgroundImage, at: 0)
        
        
    }

}
extension ExchangeViewController: CurrencyModelDelegate {

    func didRecieveDataUpdate(data: Currency) {
        print(data.rates)
    }
}
