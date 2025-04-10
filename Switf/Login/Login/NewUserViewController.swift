//
//  NewUserViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//



import UIKit
/*
struct Usuario {
    var username: String
    var password: String
    var nombre: String
    var apellido: String
    var email: String
}

var usuarios: [Usuario] = []
*/
class NewUserViewController: UIViewController {
    
    @IBOutlet weak var aceptarNewUserButton: UIButton!
    @IBOutlet weak var cancelarNewUserButton: UIButton!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newUserTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var apellidoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var tituloLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tituloLabel.text = "Ingrese sus credenciales"

    }
    
    @IBAction func aceptarNewUserButtonTapped(_ sender: UIButton) {
        guard let username = newUserTextField.text, !username.isEmpty,
              let password = newPasswordTextField.text, !password.isEmpty,
              let nombre = nombreTextField.text, !nombre.isEmpty,
              let apellido = apellidoTextField.text, !apellido.isEmpty,
              let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Por favor, completa todos los campos.")
            return
        }
        
        guard isValidEmail(email) else {
            showAlert(title: "Error", message: "El formato del correo electrónico no es válido.")
            return
        }
        
        guard !isUsernameTaken(username) else {
            showAlert(title: "Error", message: "El nombre de usuario ya existe. Elige otro.")
            return
        }
        
        saveUser(username: username, password: password, nombre: nombre, apellido: apellido, email: email)
        showAlert(title: "Éxito", message: "Usuario guardado correctamente.")
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isUsernameTaken(_ username: String) -> Bool {
        if let storedUserData = UserDefaults.standard.dictionary(forKey: "userData") as? [String: String],
           storedUserData["username"] == username {
            return true
        }
        return false
    }
    
    func saveUser(username: String, password: String, nombre: String, apellido: String, email: String) {
        let userData: [String: String] = [
            "username": username,
            "password": password,
            "nombre": nombre,
            "apellido": apellido,
            "email": email
        ]
        
        UserDefaults.standard.set(userData, forKey: "userData")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelarNewUserButtonTapped(_ sender: UIButton) {
        newUserTextField.text = ""
        newPasswordTextField.text = ""
        nombreTextField.text = ""
        apellidoTextField.text = ""
        emailTextField.text = ""
    }
}

/*
import UIKit

struct Usuario: Codable {
    var username: String
    var password: String
    var nombre: String
    var apellido: String
    var email: String
}

// Clave para almacenar usuarios en UserDefaults
let usuariosKey = "usuariosGuardados"

// Variable global para almacenar usuarios
var usuarios: [Usuario] = cargarUsuarios()

class NewUserViewController: UIViewController {
    
    @IBOutlet weak var aceptarNewUserButton: UIButton!
    @IBOutlet weak var cancelarNewUserButton: UIButton!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newUserTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var apellidoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var tituloLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tituloLabel.text = "Ingrese sus credenciales"
    }
    
    @IBAction func aceptarNewUserButtonTapped(_ sender: UIButton) {
        guard let username = newUserTextField.text, !username.isEmpty,
              let password = newPasswordTextField.text, !password.isEmpty,
              let nombre = nombreTextField.text, !nombre.isEmpty,
              let apellido = apellidoTextField.text, !apellido.isEmpty,
              let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Por favor, completa todos los campos.")
            return
        }
        
        guard isValidEmail(email) else {
            showAlert(title: "Error", message: "El formato del correo electrónico no es válido.")
            return
        }
        
        guard !isUsernameTaken(username) else {
            showAlert(title: "Error", message: "El nombre de usuario ya existe. Elige otro.")
            return
        }
        
        saveUser(username: username, password: password, nombre: nombre, apellido: apellido, email: email)
        showAlert(title: "Éxito", message: "Usuario guardado correctamente.")
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isUsernameTaken(_ username: String) -> Bool {
        return usuarios.contains { $0.username == username }
    }
    
    func saveUser(username: String, password: String, nombre: String, apellido: String, email: String) {
        let nuevoUsuario = Usuario(username: username, password: password, nombre: nombre, apellido: apellido, email: email)
        
        usuarios.append(nuevoUsuario)
        guardarUsuarios()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelarNewUserButtonTapped(_ sender: UIButton) {
        newUserTextField.text = ""
        newPasswordTextField.text = ""
        nombreTextField.text = ""
        apellidoTextField.text = ""
        emailTextField.text = ""
    }
}

// Función para guardar usuarios en UserDefaults
func guardarUsuarios() {
    let encoder = JSONEncoder()
    if let encodedData = try? encoder.encode(usuarios) {
        UserDefaults.standard.set(encodedData, forKey: usuariosKey)
    }
}

// Función para cargar usuarios almacenados
func cargarUsuarios() -> [Usuario] {
    if let savedData = UserDefaults.standard.data(forKey: usuariosKey) {
        let decoder = JSONDecoder()
        if let loadedUsers = try? decoder.decode([Usuario].self, from: savedData) {
            return loadedUsers
        }
    }
    return []
}
*/
