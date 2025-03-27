//
//  ViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//


import UIKit

class EmailViewController: UIViewController {
    
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var enviarButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelEmail.text = "Le enviaremos un correo de confirmación"
    }

    
    @IBAction func enviarButtonTapped(_ sender: UIButton) {
        guard let inputText = emailTextField.text, !inputText.isEmpty,
              let userData = UserDefaults.standard.dictionary(forKey: "userData") as? [String: String],
              let savedEmail = userData["email"], let savedUsername = userData["username"],
              inputText == savedEmail || inputText == savedUsername else {
            mostrarAlerta(titulo: "Error", mensaje: "El email o usuario ingresado no es válido.")
            return
        }
        // Verificar si ingresó el email o el username
        if inputText == savedEmail {
            // Guarda el username en UserDefaults si ingresó su email
            UserDefaults.standard.set(savedUsername, forKey: "selectedUser")
        } else if inputText == savedUsername {
            // Guarda el username si ingresó directamente su usuario
            UserDefaults.standard.set(savedUsername, forKey: "selectedUser")
        }
        
    }
    
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

