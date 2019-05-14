//
//  WelcomeViewController.swift
//  IOSFinal
//
//  Created by Kristine Legzdina on 22/04/2019.
//  Copyright © 2019 Kristine Legzdina. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.borderWidth = 2
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        registerButton.layer.borderWidth = 2
        registerButton.layer.cornerRadius = 10
        registerButton.layer.borderColor = UIColor.white.cgColor
    }
}
