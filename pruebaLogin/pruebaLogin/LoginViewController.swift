//
//  LoginViewController.swift
//  pruebaLogin
//
//  Created by bootcamp on 2025-02-24.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    super.viewDidLoad()
        
    override func viewDidLoad() {
         
        super.viewDidLoad()
        
        label.text = "Olvido su contrasenia?"
        let logginButton = UIButton(frame: CGRect(x: 0, y: 100, width: 200, height: 100))

        
        view.addSubview(logginButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

