//
//  NewUserViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//

/*
import UIKit

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
           // Configuración adicional si es necesaria
       }
       
       @IBAction func aceptarNewUserButtonTapped(_ sender: UIButton) {
           guard let username = newUserTextField.text, !username.isEmpty,
                 let password = newPasswordTextField.text, !password.isEmpty,
                 let nombre = nombreTextField.text, !nombre.isEmpty,
                 let apellido = apellidoTextField.text, !apellido.isEmpty,
                 let email = emailTextField.text, !email.isEmpty else {
               // Mostrar un mensaje de error si los campos están vacíos
               print("Por favor, completa todos los campos.")
               return
           }
           
           // Guardar el usuario en UserDefaults
           saveUser(username: username, password: password, nombre: nombre, apellido: apellido, email: email)
       }
       
       func saveUser(username: String, password: String, nombre: String, apellido: String, email: String) {
           // Crear un diccionario con los datos del usuario
           let userData: [String: String] = [
               "username": username,
               "password": password,
               "nombre": nombre,
               "apellido": apellido,
               "email": email
           ]
           
           // Guardar el diccionario en UserDefaults
           UserDefaults.standard.set(userData, forKey: "userData")
           
           print("Usuario guardado correctamente.")
       }
       
       @IBAction func cancelarNewUserButtonTapped(_ sender: UIButton) {
           // Limpiar los campos o realizar alguna acción al cancelar
           newUserTextField.text = ""
           newPasswordTextField.text = ""
           nombreTextField.text = ""
           apellidoTextField.text = ""
           emailTextField.text = ""
       }
   }
*/

import UIKit

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
    }
    
    @IBAction func aceptarNewUserButtonTapped(_ sender: UIButton) {
        guard let username = newUserTextField.text, !username.isEmpty,
              let password = newPasswordTextField.text, !password.isEmpty,
              let nombre = nombreTextField.text, !nombre.isEmpty,
              let apellido = apellidoTextField.text, !apellido.isEmpty,
              let email = emailTextField.text, !email.isEmpty else {
            print("Por favor, completa todos los campos.")
            return
        }
        
        guard isValidEmail(email) else {
            print("El formato del correo electrónico no es válido.")
            return
        }
        
        guard !isUsernameTaken(username) else {
            print("El nombre de usuario ya existe. Elige otro.")
            return
        }
        
        saveUser(username: username, password: password, nombre: nombre, apellido: apellido, email: email)
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
        print("Usuario guardado correctamente.")
    }
    
    @IBAction func cancelarNewUserButtonTapped(_ sender: UIButton) {
        newUserTextField.text = ""
        newPasswordTextField.text = ""
        nombreTextField.text = ""
        apellidoTextField.text = ""
        emailTextField.text = ""
    }
}

