//
//  GameViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-26.
//
/*
import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var ballView: UIView!
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    
    var username: String = "" // Se asigna desde el login
    var timer: Timer?
    var timeLeft = 30
    var score = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Cabecera
        userLabel.text = "Usuario: \(username)"
        timeLabel.text = "Tiempo: 30"
        scoreLabel.text = "Puntos: 0"
        
        let headerStack = UIStackView(arrangedSubviews: [userLabel, timeLabel, scoreLabel])
        headerStack.axis = .horizontal
        headerStack.distribution = .equalSpacing
        headerStack.frame = CGRect(x: 20, y: 50, width: view.frame.width - 40, height: 40)
        view.addSubview(headerStack)
        
        // Área de juego
        gameView.frame = CGRect(x: 50, y: 120, width: 300, height: 300)
        gameView.backgroundColor = .lightGray
        view.addSubview(gameView)
        
        // Bola
        ballView.frame = CGRect(x: 125, y: 125, width: 50, height: 50)
        ballView.backgroundColor = .red
        ballView.layer.cornerRadius = 25
        gameView.addSubview(ballView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ballTapped))
        ballView.addGestureRecognizer(tapGesture)
        ballView.isUserInteractionEnabled = true
        
        // Botón Start
        startButton.frame = CGRect(x: 100, y: 450, width: 200, height: 50)
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = .blue
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        view.addSubview(startButton)
    }
    
    @objc func startGame() {
        score = 0
        timeLeft = 30
        scoreLabel.text = "Puntos: 0"
        timeLabel.text = "Tiempo: 30"
        startButton.isEnabled = false
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
        ballView.frame.origin = CGPoint(x: randomX, y: randomY)
    }
    
    func showGameOverAlert() {
        let alert = UIAlertController(title: "¡Juego terminado!", message: "Puntos: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}*/

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

