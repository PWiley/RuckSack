
//  ExchangeViewController.swift
//  RuckSack
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController, CurrencyServiceDelegate {
    
    let weatherViewController = WeatherViewController()
    let currencyService = CurrencyService.sharedCurrency
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    
    // MARK: - Outlets
    
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
    
    // MARK: - Overriden Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyService.delegate = self
        setBackGroundTown()
        currencyService.askCurrencyRate()
        exchangeViewController.insertSubview(backgroundImage, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        amountOrigin.text = ""
        amountDestination.text = ""
        setBackGroundTown()
        addDoneButtonOnKeyboard()
        
    }
}
extension ExchangeViewController {

    // MARK: - Public Methods
    // MARK: ** Methods Delegate

    func didUpdateCurrencyData(eurRate: String, usdRate: String) {
        currencyOrigin.text = eurRate
        currencyDestination.text = usdRate
    }
    func didHappenedError(error: CurrencyError) {
        switch error {
        case .clientError:
            self.alert(title: "Internet Connection",
                       message: "We cannot etablish an internet connection. Please retry in a moment",
                       titleAction: "Ok",
                       actionStyle: .default)
        case .currencyError:
            self.alert(title: "Action impossible",
                       message: "Check please your entry ",
                       titleAction: "ok",
                       actionStyle: .default)
        }
    }
    // MARK: ** Methods Handling User Behavior
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done",
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.amountOrigin.inputAccessoryView = doneToolbar
        self.amountDestination.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction() {
        self.amountOrigin.resignFirstResponder()
        self.amountDestination.resignFirstResponder()
        var result: Double
        if amountOrigin.text != "" && !(amountOrigin.text?.contains(",,"))! {
            currencyService.askCurrencyRate()
            guard let amountDouble = Double(amountOrigin.text!.replacingOccurrences(of: ",", with: ".")) else {
                self.alert(title: "Action impossible",
                           message: "Check please your entry ",
                           titleAction: "ok",
                           actionStyle: .default)
                amountOrigin.text = ""
                return
            }
            result = currencyService.calculateResult(amount: amountDouble,
                base: "EUR")
            
            let resultString = String(format: "%.2f", result).replacingOccurrences(of: ".", with: ",")
            amountDestination.text = resultString
            setAlphaView(origin: 0.65, destination: 0.95)
        } else if amountDestination.text != "" && !(amountDestination.text?.contains(",,"))! {
            currencyService.askCurrencyRate()
            guard let amountDouble = Double(amountDestination.text!.replacingOccurrences(of: ",", with: "."))else {
                self.alert(title: "Action impossible",
                           message: "Check please your entry ",
                           titleAction: "ok",
                           actionStyle: .default)
                amountDestination.text = ""
                return
            }
            result = currencyService.calculateResult(amount: amountDouble,
                base: "EUR")
            let resultString = String(format: "%.2f", result).replacingOccurrences(of: ".", with: ",")
            amountOrigin.text = resultString
            setAlphaView(origin: 0.95, destination: 0.65)
        } else {
            didHappenedError(error: .currencyError)
        }
        
    }
    
// MARK: - Action Methods
    
    @IBAction func originDidBegin(_ sender: Any) {
        setAlphaView(origin: 0.95, destination: 0.65)
    }
    @IBAction func destinationDidBegin(_ sender: Any) {
        setAlphaView(origin: 0.65, destination: 0.95)
    }
    @IBAction func originChanged(_ sender: Any) {
        amountDestination.text = ""
        amountOrigin.text = amountOrigin.text?.trimmed
    }
    @IBAction func destinationChanged(_ sender: Any) {
        amountOrigin.text = ""
        amountDestination.text = amountDestination.text?.trimmed
    }
}

extension ExchangeViewController {
    
    // MARK: - Private Methods
    
    // MARK: ** Configuration Background
    
    fileprivate func setBackGroundTown() {
        let town = weatherViewController.backgroundDefault.string(forKey: "town")
        if  town == "Berlin" {
            backgroundImage.image = UIImage(named: "Background_Exchange_Berlin")
        }
        if town == "NewYork" {
            backgroundImage.image = UIImage(named:"Background_Exchange_NewYork")
        }
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
    }
    fileprivate func setAlphaView(origin: Float, destination: Float) {
        viewOrigin.alpha = CGFloat(origin)
        viewDestination.alpha = CGFloat(destination)
        amountOrigin.alpha = CGFloat(origin)
        amountDestination.alpha = CGFloat(destination)
    }
    
}
