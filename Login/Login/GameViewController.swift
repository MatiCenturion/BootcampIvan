//
//  GameViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-26.
//




import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var ballView: UIView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    var username: String = ""  // Se debe asignar antes de cargar la vista
    var timer: Timer?
    var moveTimer: Timer? // Timer para mover la bola automáticamente
    var timeLeft = 30
    var score = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelGame), for: .touchUpInside)
        
        if let userData = UserDefaults.standard.dictionary(forKey: "userData") as? [String: String] {
            let nombre = userData["nombre"] ?? "Usuario"
            userLabel.text = nombre
        } else {
            userLabel.text = "Usuario"
        }
        
        timeLabel.text = "\(timeLeft)"
        scoreLabel.text = "Puntos: \(score)"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ballTapped))
        ballView.addGestureRecognizer(tapGesture)
        
        // **Deshabilitar la interacción de la bola al inicio**
        ballView.isUserInteractionEnabled = false
    }
    
    @objc func startGame() {
        score = 0
        timeLeft = 30
        scoreLabel.text = "Puntos: \(score)"
        timeLabel.text = "\(timeLeft)"
        startButton.isEnabled = false
        
        // **Habilitar la interacción con la bola**
        ballView.isUserInteractionEnabled = true
        
        // Iniciar temporizador para el tiempo del juego
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        // **Iniciar temporizador para mover la bola automáticamente cada 0.5 segundos**
        moveTimer?.invalidate()
        moveTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(moveBall), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        if timeLeft > 0 {
            timeLeft -= 1
            timeLabel.text = "\(timeLeft)"
        } else {
            timer?.invalidate()
            moveTimer?.invalidate() // Detener el movimiento de la bola al finalizar el juego
            startButton.isEnabled = true
            
            // **Deshabilitar la interacción con la bola**
            ballView.isUserInteractionEnabled = false
            
            showGameOverAlert()
        }
    }
    
    @objc func ballTapped() {
        if timeLeft > 0 {
            score += 1
            scoreLabel.text = "Puntos: \(score)"
        }
    }
    
    @objc func moveBall() {
        let maxX = gameView.bounds.width - ballView.frame.width
        let maxY = gameView.bounds.height - ballView.frame.height
        let randomX = CGFloat.random(in: 0...maxX)
        let randomY = CGFloat.random(in: 0...maxY)
        
        UIView.animate(withDuration: 0.3) { // Animación para que se vea más fluido
            self.ballView.frame.origin = CGPoint(x: randomX, y: randomY)
        }
    }
    
    func showGameOverAlert() {
        let alert = UIAlertController(title: "¡Juego terminado!", message: "Puntos: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func cancelGame() {
        timer?.invalidate() // Detener el temporizador del tiempo de juego
        moveTimer?.invalidate() // Detener el movimiento de la bola
        
        dismiss(animated: true, completion: nil) // Cierra la pantalla y regresa a HomeViewController
    }
}
