//
//  LoginViewController.swift
//  IOSFinal
//
//  Created by Kristine Legzdina on 22/04/2019.
//  Copyright © 2019 Kristine Legzdina. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.borderWidth = 2
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){
            (user,error) in
            if error != nil{
                print(error!)
            }else{
                print("Login successful!")
                self.performSegue(withIdentifier: "goToMain", sender: self)
            }
        }
    }
}
