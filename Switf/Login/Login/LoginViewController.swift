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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuración adicional si es necesaria
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let username = userTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // Mostrar un mensaje de error si los campos están vacíos
            print("Por favor, completa todos los campos.")
            return
        }
        
        // Verificar las credenciales
        if checkCredentials(username: username, password: password) {
            print("Inicio de sesión exitoso.")
            // Navegar a HomeViewController
        } else {
            print("Credenciales incorrectas.")
            // Mostrar un mensaje de error al usuario
            showErrorAlert(message: "Credenciales incorrectas. Inténtalo de nuevo.")
        }
    }
    
    private func checkCredentials(username: String, password: String) -> Bool {
        // Recuperar los datos guardados en UserDefaults
        if let userData = UserDefaults.standard.dictionary(forKey: "userData") as? [String: String] {
            let savedUsername = userData["username"]
            let savedPassword = userData["password"]
            
            // Comparar las credenciales
            return username == savedUsername && password == savedPassword
        }
        return false
    }
    

    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func olvidoContraseniaButtonTapped(_ sender: UIButton) {
        // Implementar la lógica para recuperar la contraseña
        print("Funcionalidad de olvidé contraseña.")
    }
}
