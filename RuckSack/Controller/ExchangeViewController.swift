
//  ExchangeViewController.swift
//  Bundle
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController, CurrencyServiceDelegate {
    
    
    let currencyService = CurrencyService()
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    @IBOutlet var exchangeViewController: UIView!
    
    @IBOutlet weak var viewOrigin: DesignableView!
    @IBOutlet weak var flagCurrencyOrigin: UIImageView!
    @IBOutlet weak var shortLabelOrigin: UILabel!
    @IBOutlet weak var labelOrigin: UILabel!
    @IBOutlet weak var amountOrigin: UITextField!
    @IBOutlet weak var currencyOrigin: UILabel!
    
    @IBOutlet weak var viewDestination: DesignableView!
    @IBOutlet weak var flagCurrencyDestination: UIImageView!
    @IBOutlet weak var shortLabelDestination: UILabel!
    @IBOutlet weak var labelDestination: UILabel!
    @IBOutlet weak var amountDestination: UITextField!
    @IBOutlet weak var currencyDestination: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.hideKeyboardWhenTappedAround()
        currencyService.delegate = self
        currencyService.askCurrencyRate()
        exchangeViewController.insertSubview(backgroundImage, at: 0)
        // Do any additional setup after loading the view.
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
   
    @IBAction func originDidBegin(_ sender: Any) {
        setAlphaView(origin: 0.95, destination: 0.65)
    }
    @IBAction func destinationDidBegin(_ sender: Any) {
        setAlphaView(origin: 0.65, destination: 0.95)
    }
    
    @IBAction func originChanged(_ sender: Any) {
        amountDestination.text = ""
    }
    @IBAction func destinationChanged(_ sender: Any) {
        amountOrigin.text = ""
    }
    func didUpdateCurrencyData(eurRate: Double, usdRate: Double) {
        currencyOrigin.text = String(format:"%.4f", eurRate)
        currencyDestination.text = String(format:"%.4f", usdRate)
    }
    func didHappenedError(error: CurrencyError) {
        switch error {
        case .clientError:
            self.alert(title: "Internet Connection" , message: "We cannot etablish an internet connection. Please retry in a moment", titleAction: "Ok", actionStyle: .default)
        case .currencyError:
            self.alert(title: "Incorrect entry" , message: "Please check your entries and try again.", titleAction: "Ok", actionStyle: .default)
        }
    }
    
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
        
        if amountOrigin.text != "" {
            currencyService.askCurrencyRate()
            let amountDouble = Double(amountOrigin.text!)
            amountDestination.text = String(format:"%.2f", currencyService.calculateConversion(amount: amountDouble!, base: "EUR"))
            setAlphaView(origin: 0.65, destination: 0.95)
        }
        if amountDestination.text != "" {
            currencyService.askCurrencyRate()
            let amountDouble = Double(amountDestination.text!)
            amountOrigin.text = String(format:"%.2f", currencyService.calculateConversion(amount: amountDouble!, base: "USD"))
            setAlphaView(origin: 0.95, destination: 0.65)
        } else {
            self.alert(title: "Action impossible", message: "You didn't enter any value to exchange", titleAction: "ok", actionStyle: .default)
        }
       
    }
    
     // MARK : Configuration Background
    
    fileprivate func setBackGroundTown() {
          
           print(WeatherViewController.whichTown)
           if WeatherViewController.whichTown == true {
               backgroundImage.image = UIImage(named: "Background_Exchange_Berlin")
               backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
           } else {
               backgroundImage.image = UIImage(named: "Background_Exchange_NewYork")
               backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
           }
       }
    fileprivate func setAlphaView(origin: Float, destination: Float) {
           viewOrigin.alpha = CGFloat(origin)
           viewDestination.alpha = CGFloat(destination)
           amountOrigin.alpha = CGFloat(origin)
           amountDestination.alpha = CGFloat(destination)
       }
}
