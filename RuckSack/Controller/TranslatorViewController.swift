//
//  TranslatorViewController.swift
//  Bundle
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class TranslatorViewController: UIViewController, TranslateServiceDelegate {
    
    
    
    var translateService = TranslateService()
    
    //var sentence: String?
    //static var source: String?
    @IBOutlet var translatorViewController: UIView!
    @IBOutlet weak var flagLanguageOrigin: UIImageView!
    @IBOutlet weak var titleLanguageOrigin: UILabel!
    @IBOutlet weak var textLanguageOrigin: UITextView!
    
    @IBOutlet weak var flagLanguageDestination: UIImageView!
    @IBOutlet weak var titleLanguageDestination: UILabel!
    @IBOutlet weak var textLanguageDestination: UITextView!
    
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translateService.delegate = self
        //self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setBackGroundTown()
        translatorViewController.insertSubview(backgroundImage, at: 0)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //setBackGroundTown()
        addDoneButtonOnKeyboard()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //setBackGroundTown()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if textLanguageDestination.isFirstResponder {
                self.view.frame.origin.y = -(keyboardSize.height)/2
            }
            if textLanguageOrigin.isFirstResponder {
                self.view.frame.origin.y = -(keyboardSize.height)/14
            }
        }
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
        
        self.textLanguageOrigin.inputAccessoryView = doneToolbar
        self.textLanguageDestination.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.textLanguageOrigin.resignFirstResponder()
        self.textLanguageDestination.resignFirstResponder()
        if textLanguageOrigin.text != "" {
            textLanguageDestination.text = ""
            //print(textLanguageOrigin.text)
            //translateService.sentence = textLanguageOrigin.text
            //translateService.setLanguageTarget(target: .english)
            translateService.createRequest(sentence: textLanguageOrigin.text, targetLanguage: "en")
            //translateService.createCall()
            
        }
        if textLanguageDestination.text != "" {
            textLanguageOrigin.text = ""
            //translateService.sentence = textLanguageDestination.text
            //translateService.setLanguageTarget(target: .french)
            translateService.createRequest(sentence: textLanguageOrigin.text, targetLanguage: "fr")
            //translateService.createCall()
        }
        translateService.createCall()
        
    }
    
    func didUpdateTranslateData(translate: Translate, languageField: String) {
        let translatedAnswer = translate.data.translations[0]
//        translateService.checkLanguageTarget(target: translatedAnswer.detectedSourceLanguage)
        
        if languageField == "en" && textLanguageDestination.text != "" {
            print(translatedAnswer.translatedText)
            print("Translated from english")
            textLanguageOrigin.text = translatedAnswer.translatedText
            
        }
        if languageField == "fr" && textLanguageOrigin.text != "" {
            print(translatedAnswer.translatedText)
            print("Translated from french")
            textLanguageDestination.text = translatedAnswer.translatedText
            
        }
        
    }
    
    // MARK: Background settings
    
    fileprivate func setBackGroundTown() {
        // Do any additional setup after loading the view.
        //        'let backgroundImage = UIImageView(frame: UIScreen.main.bounds)'
        
        print(WeatherViewController.whichTown)
        if WeatherViewController.whichTown == true {
            backgroundImage.image = UIImage(named: "Background_Translator_Berlin")
        } else {
            backgroundImage.image = UIImage(named: "Background_Translator_NewYork_Ver2")
        }
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        
        //        translatorViewController.insertSubview(backgroundImage, at: 0)
    }
}
