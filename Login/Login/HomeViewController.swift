//
//  HomeViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//
/*
import UIKit

class HomeViewController: UIViewController {
    var username: String?

    @IBOutlet weak var verPuntajeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func goToLogin() {
        dismiss(animated: true, completion: nil) // Cierra la pantalla actual y vuelve a LoginViewController
    }
}
*/


import UIKit

class HomeViewController: UIViewController {
    var username: String?

    @IBOutlet weak var verPuntajeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verPuntajeButton.addTarget(self, action: #selector(verPuntajes), for: .touchUpInside)
    }

    @objc func verPuntajes() {
        let topScores = UserDefaults.standard.array(forKey: "topScores") as? [[String: Any]] ?? []
        
        var message = topScores.isEmpty ? "No hay puntajes registrados aún." : "🏆 Top 5 Puntajes:\n"
        
        for (index, entry) in topScores.enumerated() {
            let user = entry["user"] as? String ?? "Usuario"
            let score = entry["score"] as? Int ?? 0
            message += "\(index + 1). \(user): \(score) puntos\n"
        }
        
        let alert = UIAlertController(title: "Tabla de Puntajes", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func goToLogin() {
        dismiss(animated: true, completion: nil) // Cierra la pantalla actual y vuelve a LoginViewController
    }
}


