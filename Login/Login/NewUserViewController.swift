//
//  NewUserViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//

import UIKit

protocol NewUserDelegate: AnyObject {
    func didAddNewUser(username: String, password: String)
}
    class NewUserViewController: UIViewController {
        
       
        @IBOutlet weak var aceptarNewUserButton: UIButton!
        @IBOutlet weak var cancelarNewUserbutton: UIButton!
        @IBOutlet weak var newPasswordTextField: UITextField!
        @IBOutlet weak var newUserTextField: UITextField!
        @IBOutlet weak var tituloLabel: UILabel!
        
        weak var delegate: NewUserDelegate? // Agregar delegado
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tituloLabel.text = "Ingrese Nuevo Usuario"
        }

        @IBAction func aceptarNewUser(_ sender: UIButton) {
            guard let newUser = newUserTextField.text, !newUser.isEmpty,
                  let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
                return
            }
       
            // Notificar al delegado
            delegate?.didAddNewUser(username: newUser, password: newPassword)
            self.dismiss(animated: true, completion: nil) // Cerrar la vista después de agregar el usuario
        }
        
        @IBAction func cancelarNewUser(_ sender: UIButton) {
            self.dismiss(animated: true, completion: nil)
        }
        
        

        
    }

