//
//  NewUserViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//

import UIKit

// Protocolo para delegar la acción de agregar un nuevo usuario
protocol NewUserDelegate: AnyObject {
    func didAddNewUser(username: String, password: String)
}

class NewUserViewController: UIViewController {
    
    @IBOutlet weak var aceptarNewUserButton: UIButton!
    @IBOutlet weak var cancelarNewUserButton: UIButton!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newUserTextField: UITextField!
    @IBOutlet weak var tituloLabel: UILabel!
    
    weak var delegate: NewUserDelegate? // Referencia al delegado
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tituloLabel.text = "Ingrese Nuevo Usuario"
        
        // Redondear los botones para evitar errores con CoreGraphics
//        aceptarNewUserButton.layer.cornerRadius = 10
//        cancelarNewUserButton.layer.cornerRadius = 10
    }

    @IBAction func aceptarNewUser(_ sender: UIButton) {
        guard let newUser = newUserTextField.text, !newUser.isEmpty,
              let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            showAlert(message: "Debe ingresar usuario y contraseña.")
            return
        }
        
        // Notificar al delegado que se agregó un nuevo usuario
        delegate?.didAddNewUser(username: newUser, password: newPassword)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelarNewUser(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Método auxiliar para mostrar alertas
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


