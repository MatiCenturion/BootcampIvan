//
//  GameViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-26.
//


import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var ballView: UIView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    var username: String = ""  // Se debe asignar antes de cargar la vista
    var timer: Timer?
    var timeLeft = 30
    var score = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)

        // ✅ Asegurar que el nombre de usuario se muestra correctamente
        userLabel.text = "Usuario: \(username.isEmpty ? "Invitado" : username)"
        
        // ✅ Inicializar etiquetas correctamente
        timeLabel.text = "Tiempo: \(timeLeft)"
        scoreLabel.text = "Puntos: \(score)"
        
        // Configurar gestos en la bola
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ballTapped))
        ballView.addGestureRecognizer(tapGesture)
        ballView.isUserInteractionEnabled = true
    }
    
    @objc func startGame() {
        score = 0
        timeLeft = 30
        scoreLabel.text = "Puntos: \(score)"
        timeLabel.text = "Tiempo: \(timeLeft)"
        startButton.isEnabled = false
        
        // ✅ Iniciar el temporizador
        timer?.invalidate()  // Detiene cualquier temporizador previo
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        if timeLeft > 0 {
            timeLeft -= 1
            timeLabel.text = "Tiempo: \(timeLeft)"
        } else {
            timer?.invalidate()
            startButton.isEnabled = true
            showGameOverAlert()
        }
    }
    
    @objc func ballTapped() {
        if timeLeft > 0 {
            score += 1
            scoreLabel.text = "Puntos: \(score)"
            moveBall()
        }
    }
    
    func moveBall() {
        let maxX = gameView.bounds.width - ballView.frame.width
        let maxY = gameView.bounds.height - ballView.frame.height
        let randomX = CGFloat.random(in: 0...maxX)
        let randomY = CGFloat.random(in: 0...maxY)
        
        UIView.animate(withDuration: 0.2) {
            self.ballView.frame.origin = CGPoint(x: randomX, y: randomY)
        }
    }
    
    func showGameOverAlert() {
        let alert = UIAlertController(title: "¡Juego terminado!", message: "Puntos: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

