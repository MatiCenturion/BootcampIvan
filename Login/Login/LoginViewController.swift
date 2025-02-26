//
//  LoginViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//
import UIKit

class LoginViewController: UIViewController, NewUserDelegate {
    
    @IBOutlet weak var olvidoContraseniaButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Lista de usuarios válidos
    var validUsers: [String: String] = [
        "usuario1": "password1",
        "usuario2": "password2",
        "usuario3": "password3"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController cargado")

        // Estilizar botones para evitar problemas de renderizado
        loginButton.layer.cornerRadius = 10
    }
    
    // Acción para iniciar sesión
    @IBAction func actionLogin(_ sender: Any) {
        print("Botón de login presionado")
        
        guard let username = userTextField.text, let password = passwordTextField.text,
              !username.isEmpty, !password.isEmpty else {
            showAlert(message: "Por favor, ingrese usuario y contraseña.")
            return
        }
        
        if validUsers[username] == password {
            goToHome(username: username)
        } else {
            showAlert(message: "Usuario o contraseña incorrectos.")
        }
    }
    
    // Método para navegar a la pantalla de inicio
    func goToHome(username: String) {
        if let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeID") as? HomeViewController {
            homeVC.username = username
            homeVC.modalPresentationStyle = .fullScreen
            present(homeVC, animated: true, completion: nil)
        } else {
            print("Error: No se pudo instanciar HomeViewController")
        }
    }
    
    // Método auxiliar para mostrar alertas
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Implementación del protocolo NewUserDelegate
    func didAddNewUser(username: String, password: String) {
        validUsers[username] = password
        print("Nuevo usuario agregado: \(username)")
    }
    
    // Acción para agregar un nuevo usuario
    @IBAction func agregarNuevoUsuario(_ sender: Any) {
        if let newUserVC = storyboard?.instantiateViewController(withIdentifier: "NewUserViewControllerID") as? NewUserViewController {
            newUserVC.delegate = self  // Configurar el delegado
            present(newUserVC, animated: true, completion: nil)
        }
    }
}
