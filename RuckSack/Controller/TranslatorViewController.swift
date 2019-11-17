//
//  TranslatorViewController.swift
//  RuckSack
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class TranslatorViewController: UIViewController, TranslateServiceDelegate, UITextViewDelegate {
    
    let weatherViewController = WeatherViewController()
    var translateService = TranslateService(translateSession: .shared)
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    
    // MARK: Outlets
    @IBOutlet var translatorViewController: UIView!
    @IBOutlet weak var viewOrigin: DesignableView!
    @IBOutlet weak var flagLanguageOrigin: UIImageView!
    @IBOutlet weak var titleLanguageOrigin: UILabel!
    @IBOutlet weak var textLanguageOrigin: UITextView!
    
    @IBOutlet weak var viewDestination: DesignableView!
    @IBOutlet weak var flagLanguageDestination: UIImageView!
    @IBOutlet weak var titleLanguageDestination: UILabel!
    @IBOutlet weak var textLanguageDestination: UITextView!
    
    // MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        translateService.delegate = self
        
        setBackGroundTown()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        textLanguageOrigin.delegate = self
        textLanguageDestination.delegate = self
        translatorViewController.insertSubview(backgroundImage, at: 0)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textLanguageOrigin.text = ""
        textLanguageDestination.text = ""
        setBackGroundTown()
        addDoneButtonOnKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}


extension TranslatorViewController {
    // MARK: - Public Methods
    
    // MARK: ** Methods Delegate
    func didUpdateTranslateData(translate: Translate, targetLanguage: String) {
        let translatedAnswer = translate.data.translations[0]
        switch targetLanguage {
        case "fr":
        if textLanguageOrigin.text != "" {
            textLanguageOrigin.text = ""
            self.alert(title: "Action impossible", message: "Check your entry", titleAction: "ok", actionStyle: .default)
        }
        else {
            textLanguageOrigin.text = translatedAnswer.translatedText
            viewOrigin.alpha = 0.85
            }
        case "en": 
        if textLanguageDestination.text != "" {
            textLanguageDestination.text = ""
            self.alert(title: "Action impossible", message: "Check your entry", titleAction: "ok", actionStyle: .default)
        }
        else {
            textLanguageDestination.text = translatedAnswer.translatedText
            viewDestination.alpha = 0.85
            }
        default: print("error")
        }
    }
    func didHappenedError(error: TranslationError) {
        switch error {
        case .clientError, .responseError, .jsonError: alert(title: "Internet Connection",
                                                             message: "We cannot etablish an internet connection. Please retry in a moment",
                                                             titleAction: "Ok",
                                                             actionStyle: .default)
        case .wrongLanguage: alert(title: "Incorrect entry" ,
                                   message: "Please check your entries and try again.",
                                   titleAction: "Ok",
                                   actionStyle: .default)
        
        textLanguageOrigin.text = ""
        textLanguageOrigin.text = ""
        }
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == textLanguageOrigin {
            textLanguageDestination.text = ""
            viewOrigin.alpha = 0.85
            viewDestination.alpha = 0.65
        }
        if textView == textLanguageDestination {
            textLanguageOrigin.text = ""
            viewDestination.alpha = 0.85
            viewOrigin.alpha = 0.65
        }
    }
    
    // MARK: ** Methods Handling User Behavior
    
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
        viewOrigin.alpha = 0.65
        viewDestination.alpha = 0.65
        if textLanguageOrigin.text != "" {
            translateService.createRequest(sentence: textLanguageOrigin.text, targetLanguage: "en")
            translateService.askTranslation()
        }
        if textLanguageDestination.text != "" {
            translateService.createRequest(sentence: textLanguageDestination.text, targetLanguage: "fr")
            translateService.askTranslation()
        }
        if textLanguageOrigin.text == "" && textLanguageDestination.text == ""{
            self.alert(title: "Action impossible", message: "You didn't enter any text to translate", titleAction: "ok", actionStyle: .default)
        }
        
        
    }
    // MARK: ** Action Methods
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if textLanguageDestination.isFirstResponder {
                self.view.frame.origin.y = -(keyboardSize.height)/1.5
            }
        }
    }
}
extension TranslatorViewController {
    // MARK: - Private Methods
    
    // MARK: ** Background settings
    
    fileprivate func setBackGroundTown() {
        // Do any additional setup after loading the view.
        //        'let backgroundImage = UIImageView(frame: UIScreen.main.bounds)'
        let town = weatherViewController.backgroundDefault.string(forKey: "town")
        if  town == "Berlin" {
            backgroundImage.image = UIImage(named: "Background_Translator_Berlin")
            
        }
        if town == "NewYork" {
            backgroundImage.image = UIImage(named:"Background_Translator_NewYork")
            
        }
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        
    }
}
