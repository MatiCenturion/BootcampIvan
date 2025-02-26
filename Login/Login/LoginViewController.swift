//
//  LoginViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//

import UIKit

class LoginViewController: UIViewController, NewUserDelegate {  // Implementa el protocolo
    
    @IBOutlet weak var olvidoContraseniaButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Lista de usuarios y contraseñas válidas
    var validUsers: [String: String] = [
        "usuario1": "password1",
        "usuario2": "password2",
        "usuario3": "password3"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController loaded")
    }
    
    // MARK: - Actions
    @IBAction func actionLogin(_ sender: Any) {
        print("Log In button pressed")
        
        guard let username = userTextField.text, let password = passwordTextField.text, !username.isEmpty, !password.isEmpty else {
            showAlert(message: "Por favor, ingrese usuario y contraseña.")
            return
        }
        
        if validUsers[username] == password {
            goToHome(username: username)  // ← Pasamos el usuario autenticado
        } else {
            showAlert(message: "Usuario o contraseña incorrectos.")
        }
    }

    
    
    
    // MARK: - Navigation
    func goToHome(username: String) {  // ← Recibimos el usuario como parámetro
        if let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeID") as? HomeViewController {
            homeVC.username = username  // ← Pasamos el usuario autenticado
            homeVC.modalPresentationStyle = .fullScreen
            present(homeVC, animated: true, completion: nil)
        } else {
            print("Error: No se pudo instanciar HomeViewController")
        }
    }

    
    // MARK: - Helper Methods
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - NewUserDelegate
    func didAddNewUser(username: String, password: String) {
        validUsers[username] = password
        print("Nuevo usuario agregado: \(username)")
    }
    
    // Presentar NewUserViewController
    @IBAction func agregarNuevoUsuario(_ sender: Any) {
        if let newUserVC = storyboard?.instantiateViewController(withIdentifier: "NewUserViewControllerID") as? NewUserViewController {
            newUserVC.delegate = self  // Establecer el delegado
            present(newUserVC, animated: true, completion: nil)
        }
    }
}





