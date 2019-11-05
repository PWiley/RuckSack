
//  ExchangeViewController.swift
//  Bundle
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

//class DoneButtonTextField: UITextField {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setUp()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setUp()
//    }
//
//    func setUp() {
//        addDoneButtonOnKeyboard()
//    }
//
//    func addDoneButtonOnKeyboard()
//    {
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//        doneToolbar.barStyle = .default
//
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
//
//        let items = [flexSpace, done]
//        doneToolbar.items = items
//        doneToolbar.sizeToFit()
//
//        self.inputAccessoryView = doneToolbar
//    }
//
//    @objc func doneButtonAction()
//    {
//        self.resignFirstResponder()
//        print("doneButtonAction")
////        let currencyState = CurrencyModel()
////        currencyState.askCurrencyRate()
//    }
//}

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
        currencyModel.delegate = self
       // exchange.currencies = exchange.createCurrency()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background_Exchange")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
//        exchangeViewController.insertSubview(backgroundImage, at: 0)
        
        
    }
    
    

}
extension ExchangeViewController: CurrencyModelDelegate {

    func didRecieveDataUpdate(data: Currency) {
        print(data.rates)
        amountOrigin.text = "12345324"
    }
}
