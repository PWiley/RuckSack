//
//  TranslatorViewController.swift
//  Bundle
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class TranslatorViewController: UIViewController, TranslateServiceDelegate, UITextViewDelegate {
    
    
    
    var translateService = TranslateService()
   
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
        textLanguageOrigin.delegate = self
        textLanguageDestination.delegate = self
        setBackGroundTown()
        translatorViewController.insertSubview(backgroundImage, at: 0)
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == textLanguageOrigin {
            textLanguageDestination.text = ""
            print("TEXT ORIGIN")
            
        }
        if textView == textLanguageDestination {
            textLanguageOrigin.text = ""
            print("TEXT DESTINATION")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        setBackGroundTown()
        addDoneButtonOnKeyboard()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setBackGroundTown()
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
            translateService.createRequest(sentence: textLanguageOrigin.text, targetLanguage: "en")
        }
        if textLanguageDestination.text != "" {
            translateService.createRequest(sentence: textLanguageDestination.text, targetLanguage: "fr")
        }
        translateService.createCall()
        
    }
    
    func didUpdateTranslateData(translate: Translate, targetLanguage: String) {
        let translatedAnswer = translate.data.translations[0]
        
        //if targetLanguage == "fr" && textLanguageOrigin.text != "" {
        if targetLanguage == "fr" {
            print(translatedAnswer.translatedText)
            print("Translated from English")
            textLanguageOrigin.text = translatedAnswer.translatedText
            
        }
        if targetLanguage == "en" {
        //if targetLanguage == "en" && textLanguageDestination.text != "" {
            print(translatedAnswer.translatedText)
            print("Translated from French")
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
            backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        } else {
            backgroundImage.image = UIImage(named: "Background_Translator_NewYork_Ver2")
            backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        }
        
    }
}
