
//  ExchangeViewController.swift
//  Bundle
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController, CurrencyModelDelegate {
    
    let currencyModel = CurrencyModel()
    
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
        currencyModel.delegate = self
        currencyModel.askCurrencyRate()
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        //backgroundImage.image = UIImage(named: "Background_Exchange_Berlin")
        //backgroundImage.image = UIImage(named: "Background_Exchange_NewYork")
        
        if WeatherViewController.whichTown == true {
        backgroundImage.image = UIImage(named: "Background_Translator_Berlin")
        } else {
        backgroundImage.image = UIImage(named: "Background_Translator_NewYork")
        }
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        exchangeViewController.insertSubview(backgroundImage, at: 0)
        addDoneButtonOnKeyboard()
                
    }
    func didUpdateCurrencyData(data: Currency) {
        print(currencyModel.currency?.rates)
    }
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.amountOrigin.inputAccessoryView = doneToolbar
        self.amountDestination.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.amountOrigin.resignFirstResponder()
        self.amountDestination.resignFirstResponder()
        let currency = CurrencyModel()
        currency.askCurrencyRate()
        print(currency.exchangeView?.amountOrigin.text)
        currency.amountOrigin = currency.exchangeView?.amountOrigin.text
        print("The amountOrigin is :\(currency.amountOrigin)")
    }
}
