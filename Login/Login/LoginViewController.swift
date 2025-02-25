//
//  LoginViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var olvidoContraseniaButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var users: [String: String] = [
        "usuario1": "password1",
        "usuario2": "password2",
        "usuario3": "password3"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Acción cuando se presiona el botón login
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        validateLogin()
    }
    
    func validateLogin() {
        guard let username = userTextField.text, !username.isEmpty else {
            showAlert(message: "Por favor ingrese un nombre de usuario.")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Por favor ingrese una contraseña.")
            return
        }
        
        if let storedPassword = users[username], storedPassword == password {
            // Si el usuario y la contraseña son correctos, navega a la pantalla principal
            goToHome()
        } else {
            // Si la validación falla, mostramos un mensaje de error
            showAlert(message: "Usuario o contraseña incorrectos.")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToHome() {
        // Solo navega si la validación fue exitosa
        if let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeID") as? HomeViewController {
            navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Este método es opcional para preparar cualquier segue adicional.
    }
}





