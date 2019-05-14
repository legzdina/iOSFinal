//
//  RegisterViewController.swift
//  IOSFinal
//
//  Created by Kristine Legzdina on 22/04/2019.
//  Copyright © 2019 Kristine Legzdina. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.borderWidth = 2
        registerButton.layer.cornerRadius = 10
        registerButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){
            (user,error) in
            if error != nil{
                print(error!)
            }else{
                print("Registration successful!")
                self.performSegue(withIdentifier: "goToLogin", sender: self)
            }
        }
    }
}
