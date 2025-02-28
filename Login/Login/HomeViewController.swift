//
//  HomeViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//

import UIKit

class HomeViewController: UIViewController {
    var username: String?

    @IBOutlet weak var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside) // Asigna la acción al botón
    }

    @IBAction func jugarButtonTapped(_ sender: UIButton) {
        goToGame()
    }

    func goToGame() {
        if let gameVC = storyboard?.instantiateViewController(withIdentifier: "GameViewControllerID") as? GameViewController {
            gameVC.username = username ?? "Invitado"
            gameVC.modalPresentationStyle = .fullScreen
            present(gameVC, animated: true, completion: nil)
        } else {
            print("Error: No se pudo instanciar GameViewController")
        }
    }

    @objc func goToLogin() {
        dismiss(animated: true, completion: nil) // Cierra la pantalla actual y vuelve a LoginViewController
    }
}



