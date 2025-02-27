//
//  LoginViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//
/*import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var olvidoContraseniaButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Clave para guardar usuarios en UserDefaults
    private let usersKey = "registeredUsers"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController cargado")
    }
    
    // Acción para iniciar sesión
    @IBAction func actionLogin(_ sender: Any) {
        print("Botón de login presionado")
        
        guard let username = userTextField.text, let password = passwordTextField.text,
              !username.isEmpty, !password.isEmpty else {
            showAlert(message: "Por favor, ingrese usuario y contraseña.")
            return
        }
        
        // Verificar si el usuario existe en UserDefaults
        print(UserDefaults.standard.dictionary(forKey: usersKey))
        if let savedUsers = UserDefaults.standard.dictionary(forKey: usersKey) as? [String: String]/*,
           savedUsers[username] == password*/{
            
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
    
    // Acción para agregar un nuevo usuario
    @IBAction func agregarNuevoUsuario(_ sender: Any) {
        if let newUserVC = storyboard?.instantiateViewController(withIdentifier: "NewUserViewControllerID") as? NewUserViewController {
            // Usar un closure para manejar la adición de nuevos usuarios
            newUserVC.onUserAdded = { [weak self] username, password in
                self?.saveUser(username: username, password: password)
            }
            present(newUserVC, animated: true, completion: nil)
        }
    }
    
    // Guardar un nuevo usuario en UserDefaults
    private func saveUser(username: String, password: String) {
        var savedUsers = UserDefaults.standard.dictionary(forKey: usersKey) as? [String: String] ?? [:]
        savedUsers[username] = password
        UserDefaults.standard.set(savedUsers, forKey: usersKey)
        print("Nuevo usuario guardado: \(username)")
    }
}*/
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
            navigateToHomeViewController()
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
    
    private func navigateToHomeViewController() {
        // Asegúrate de que el identificador "HomeViewController" coincida con el que tienes en tu Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeViewController = storyboard.instantiateViewController(withIdentifier: "homeID") as? HomeViewController {
            // Puedes pasar datos a HomeViewController si es necesario
            homeViewController.modalPresentationStyle = .fullScreen
            self.present(homeViewController, animated: true, completion: nil)
        }
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
