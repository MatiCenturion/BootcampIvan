//
//  ViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//


/*
import UIKit

class EmailViewController: UIViewController {
    
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var enviarButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelEmail.text = "Le enviaremos un correo de confirmacion"
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}
 */
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
        
//        mostrarAlerta(titulo: "Éxito", mensaje: "Correo de confirmación enviado correctamente.")
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
