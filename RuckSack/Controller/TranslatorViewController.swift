//
//  TranslatorViewController.swift
//  Bundle
//
//  Created by Patrick Wiley on 29.08.19.
//  Copyright © 2019 Patrick Wiley. All rights reserved.
//

import UIKit

class TranslatorViewController: UIViewController {
    
    //var translate = Translate()
    
    @IBOutlet var translatorViewController: UIView!
    @IBOutlet weak var flagLanguageOrigin: UIImageView!
    @IBOutlet weak var titleLanguageOrigin: UILabel!
    @IBOutlet weak var textLanguageOrigin: UITextView!
    
    @IBOutlet weak var flagLanguageDestination: UIImageView!
    @IBOutlet weak var titleLanguageDestination: UILabel!
    @IBOutlet weak var textLanguageDestination: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background_Translator")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        translatorViewController.insertSubview(backgroundImage, at: 0)
      
    }  
    
}
