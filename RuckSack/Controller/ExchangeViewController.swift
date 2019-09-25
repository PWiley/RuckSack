
//  ExchangeViewController.swift
//  Bundle
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController {
    var exchange = Exchange()
    
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
        
        exchange.currencies = exchange.createCurrency()
        
        // Do any additional setup after loading the view.
    }
    fileprivate func extractedFunc() {
        // MARK: set the informations for the two views
        
        flagCurrencyOrigin.image = exchange.currencies[0].image
        shortLabelOrigin.text = exchange.currencies[0].shortLabel
        labelOrigin.text = exchange.currencies[0].name
        amountOrigin.text = exchange.currencies[0].amount
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background_Exchange")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        exchangeViewController.insertSubview(backgroundImage, at: 0)
        navigationController?.hidesBarsWhenKeyboardAppears = true
        
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(resetTapped))
        bar.items = [done]
        bar.sizeToFit()
        amountDestination.inputAccessoryView = bar
        amountOrigin.inputAccessoryView = bar
        
        
        setCurrency(currency: exchange.currencies[0])
        
        flagCurrencyDestination.image = exchange.currencies[1].image
        shortLabelDestination.text = exchange.currencies[1].shortLabel
        labelDestination.text = exchange.currencies[1].name
        amountDestination.text = exchange.currencies[1].amount
        
    }
    @objc func resetTapped() {
        if amountOrigin.isEditing == true {
            print("YES it s amountOrigin")
        }
        if amountDestination.isEditing == true {
            print("YES it s amountDestination")
        }
    }
    func setCurrency(currency: Currency) {
        
        flagCurrencyDestination.image = exchange.currencies[1].image
        shortLabelDestination.text = exchange.currencies[1].shortLabel
        labelDestination.text = exchange.currencies[1].name
        amountDestination.text = exchange.currencies[1].amount
    }
}
