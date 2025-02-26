//
//  GameViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-26.
//


import UIKit

class GameViewController: UIViewController {
    
    var username: String = ""
    var score: Int = 0
    var timeLeft: Int = 30
    var timer: Timer?
    
    let scoreLabel = UILabel()
    let timeLabel = UILabel()
    let gameAreaView = UIView()
    let ballButton = UIButton()
    let startButton = UIButton()
        
    @IBOutlet weak var usernameLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        usernameLabel.text = "Jugador: \(username)"  
    }

    
    func setupUI() {
        view.backgroundColor = .white
        
        // Configuración de la cabecera
        let headerView = UIView()
        headerView.backgroundColor = .lightGray
        headerView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 50)
        view.addSubview(headerView)
        
        let usernameLabel = UILabel()
        usernameLabel.text = "Jugador: \(username)"
        usernameLabel.frame = CGRect(x: 10, y: 10, width: 150, height: 30)
        headerView.addSubview(usernameLabel)
        
        timeLabel.text = "Tiempo: \(timeLeft)"
        timeLabel.frame = CGRect(x: view.frame.width / 2 - 50, y: 10, width: 100, height: 30)
        headerView.addSubview(timeLabel)
        
        scoreLabel.text = "Puntos: \(score)"
        scoreLabel.frame = CGRect(x: view.frame.width - 120, y: 10, width: 100, height: 30)
        headerView.addSubview(scoreLabel)
        
        // Configuración del área de juego
        gameAreaView.frame = CGRect(x: 50, y: 150, width: view.frame.width - 100, height: view.frame.width - 100)
        gameAreaView.backgroundColor = .systemGray5
        view.addSubview(gameAreaView)
        
        // Configuración de la bola
        ballButton.frame = CGRect(x: gameAreaView.frame.width / 2 - 25, y: gameAreaView.frame.height / 2 - 25, width: 50, height: 50)
        ballButton.backgroundColor = .red
        ballButton.layer.cornerRadius = 25
        ballButton.addTarget(self, action: #selector(ballTapped), for: .touchUpInside)
        gameAreaView.addSubview(ballButton)
        
        // Configuración del botón Start
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = .blue
        startButton.frame = CGRect(x: view.frame.width / 2 - 50, y: view.frame.height - 100, width: 100, height: 50)
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        view.addSubview(startButton)
    }
    
    @objc func startGame() {
        startButton.isEnabled = false
        score = 0
        scoreLabel.text = "Puntos: \(score)"
        timeLeft = 30
        timeLabel.text = "Tiempo: \(timeLeft)"
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if timeLeft > 0 {
            timeLeft -= 1
            timeLabel.text = "Tiempo: \(timeLeft)"
        } else {
            timer?.invalidate()
            startButton.isEnabled = true
        }
    }
    
    @objc func ballTapped() {
        score += 1
        scoreLabel.text = "Puntos: \(score)"
        
        let maxX = gameAreaView.frame.width - ballButton.frame.width
        let maxY = gameAreaView.frame.height - ballButton.frame.height
        
        let randomX = CGFloat.random(in: 0...maxX)
        let randomY = CGFloat.random(in: 0...maxY)
        
        UIView.animate(withDuration: 0.2) {
            self.ballButton.frame.origin = CGPoint(x: randomX, y: randomY)
        }
    }
}



