//
//  UpdatePasswordViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//
/*
import UIKit

class UpdatePasswordViewController: UIViewController {

    @IBOutlet weak var AcpetarPasswordButton: UIButton!
    @IBOutlet weak var cancelPasswordButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
*/
/*
import UIKit

class UpdatePasswordViewController: UIViewController {

    @IBOutlet weak var aceptarPasswordButton: UIButton!
    @IBOutlet weak var cancelPasswordButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!

    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func aceptarPasswordButtonTapped(_ sender: UIButton) {
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            mostrarAlerta(titulo: "Error", mensaje: "Por favor, completa todos los campos.")
            return
        }
        
        guard newPassword == confirmPassword else {
            mostrarAlerta(titulo: "Error", mensaje: "Las contraseñas no coinciden.")
            return
        }
        
        guard let username = username,
              var userData = UserDefaults.standard.dictionary(forKey: "userData") as? [String: String],
              userData["username"] == username else {
            mostrarAlerta(titulo: "Error", mensaje: "El usuario no existe.")
            return
        }
        
        // Guardar la nueva contraseña
        userData["password"] = newPassword
        UserDefaults.standard.set(userData, forKey: "userData")
        
        mostrarAlerta(titulo: "Éxito", mensaje: "Contraseña actualizada correctamente.") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelPasswordButtonTapped(_ sender: UIButton) {
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
    }

    func mostrarAlerta(titulo: String, mensaje: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
*/
import UIKit

class UpdatePasswordViewController: UIViewController {

    @IBOutlet weak var aceptarPasswordButton: UIButton!
    @IBOutlet weak var cancelPasswordButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    var selectedUser: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Recuperar el usuario guardado en UserDefaults
        if let username = UserDefaults.standard.string(forKey: "selectedUser") {
            selectedUser = username
            print("Usuario seleccionado: \(username)") // Debugging
        } else {
            mostrarAlerta(titulo: "Error", mensaje: "No se encontró un usuario válido.")
        }
    }
    
    @IBAction func aceptarPasswordTapped(_ sender: UIButton) {
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            mostrarAlerta(titulo: "Error", mensaje: "Los campos de contraseña no pueden estar vacíos.")
            return
        }
        
        // Validar que ambas contraseñas sean iguales
        guard newPassword == confirmPassword else {
            mostrarAlerta(titulo: "Error", mensaje: "Las contraseñas no coinciden.")
            return
        }
        
        // Obtener los datos guardados en UserDefaults
        if var userData = UserDefaults.standard.dictionary(forKey: "userData") as? [String: String],
           let username = selectedUser {
            
            // Verificar si el usuario existe en los datos guardados
            if userData["username"] == username {
                // Actualizar la contraseña
                userData["password"] = newPassword
                
                // Guardar nuevamente los datos actualizados
                UserDefaults.standard.set(userData, forKey: "userData")
                UserDefaults.standard.synchronize()
                
                mostrarAlerta(titulo: "Éxito", mensaje: "Contraseña actualizada correctamente.") { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                mostrarAlerta(titulo: "Error", mensaje: "No se encontró el usuario en los datos guardados.")
            }
        } else {
            mostrarAlerta(titulo: "Error", mensaje: "No se encontraron datos de usuario.")
        }
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: accion))
        present(alert, animated: true, completion: nil)
    }
}
