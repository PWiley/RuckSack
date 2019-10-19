
//  ExchangeViewController.swift
//  Bundle
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    let currencyModel = CurrencyModel()
    
    
    @IBOutlet var exchangeViewController: UIView!
    
    @IBOutlet weak var viewOrigin: DesignableView!
    @IBOutlet weak var flagCurrencyOrigin: UIImageView!
    @IBOutlet weak var shortLabelOrigin: UILabel!
    @IBOutlet weak var labelOrigin: UILabel!
    @IBOutlet weak var amountOrigin: UITextField!
    
    @IBOutlet weak var viewDestination: DesignableView!
    @IBOutlet weak var flagCurrencyDestination: UIImageView!
    @IBOutlet weak var shortLabelDestination: UILabel!
    @IBOutlet weak var labelDestination: UILabel!
    @IBOutlet weak var amountDestination: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //currencyModel.delegate = self
        currencyModel.askCurrencyRate()
        setBackGroundTown()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setBackGroundTown() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        if WeatherViewController.whichTown == true {
            backgroundImage.image = UIImage(named: "Background_Exchange_Berlin")
        } else {
            backgroundImage.image = UIImage(named: "Background_Exchange_NewYork")
        }
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        exchangeViewController.insertSubview(backgroundImage, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setBackGroundTown()
addDoneButtonOnKeyboard()
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setBackGroundTown()
        addDoneButtonOnKeyboard()
    }
//    func didUpdateCurrencyData(data: Currency) {
//        print(currencyModel.currency?.rates as Any)
//    }
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
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
        
        if amountOrigin.text != nil {
            guard let amountDouble = Double(amountOrigin.text!) else {return}
            currencyModel.calculateConversion(amount: amountDouble)
        } else {
            guard let amountDouble = Double(amountDestination.text!) else {return}
            currencyModel.calculateConversion(amount: amountDouble)
        }
        
        
        currency.askCurrencyRate()
        
    }
}
