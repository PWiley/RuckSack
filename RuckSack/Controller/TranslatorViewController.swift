//
//  TranslatorViewController.swift
//  Bundle
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class TranslatorViewController: UIViewController {
    
    var translate = Translate()
    
    @IBOutlet var translatorViewController: UIView!
    @IBOutlet weak var flagLanguageOrigin: UIImageView!
    @IBOutlet weak var titleLanguageOrigin: UILabel!
    @IBOutlet weak var textLanguageOrigin: UITextView!
    
    @IBOutlet weak var flagLanguageDestination: UIImageView!
    @IBOutlet weak var titleLanguageDestination: UILabel!
    @IBOutlet weak var textLanguageDestination: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableViewTranslator.estimatedRowHeight = 200
        translate.languages = translate.createLanguage()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background_Translator")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        translatorViewController.insertSubview(backgroundImage, at: 0)
//navigationController?.hidesBarsWhenKeyboardAppears = true
        
//        let bar = UIToolbar()
//        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(resetTapped))
//        bar.items = [done]
//        bar.sizeToFit()
//        textLanguageOrigin.inputAccessoryView = bar
//        textLanguageDestination.inputAccessoryView = bar
        
        
    }
//    @objc func resetTapped() {
//        if textLanguageOrigin.isEditable == true {
//            print("YES it s translateOrigin")
//            textLanguageOrigin.isEditable = true
//        } else if textLanguageDestination.isEditable == true{
//            print("YES it s translateDestination")
//            textLanguageDestination.isEditable = true
//        }
//    }
    
    
}
