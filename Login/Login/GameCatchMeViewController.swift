//
//  GameViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-26.
//




import UIKit

class GameCatchMeViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var ballView: UIView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    var username: String = ""
    var timer: Timer?
    var moveTimer: Timer?
    var timeLeft = 30
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelGame), for: .touchUpInside)
        
        if let userData = UserDefaults.standard.dictionary(forKey: "userData") as? [String: String] {
            username = userData["nombre"] ?? "Usuario"
            userLabel.text = username
        }
        
        timeLabel.text = "\(timeLeft)"
        scoreLabel.text = "Puntos: \(score)"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ballTapped))
        ballView.addGestureRecognizer(tapGesture)
        ballView.isUserInteractionEnabled = false
    }
    
    @objc func startGame() {
        score = 0
        timeLeft = 30
        scoreLabel.text = "Puntos: \(score)"
        timeLabel.text = "\(timeLeft)"
        startButton.isEnabled = false
        ballView.isUserInteractionEnabled = true
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        moveTimer?.invalidate()
        moveTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(moveBall), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        if timeLeft > 0 {
            timeLeft -= 1
            timeLabel.text = "\(timeLeft)"
        } else {
            timer?.invalidate()
            moveTimer?.invalidate()
            startButton.isEnabled = true
            ballView.isUserInteractionEnabled = false
            
            let isTop5 = saveScore()
            showGameOverAlert(isTop5: isTop5)
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
        
        UIView.animate(withDuration: 0.3) {
            self.ballView.frame.origin = CGPoint(x: randomX, y: randomY)
        }
    }
    
    func showGameOverAlert(isTop5: Bool) {
        var topScores = UserDefaults.standard.array(forKey: "topScores") as? [[String: Any]] ?? []
        
        topScores.sort { ($0["score"] as? Int ?? 0) > ($1["score"] as? Int ?? 0) }
        
        var message = isTop5 ? "🎉 ¡Felicidades! Entraste al Top 5 🎉\n\n" : "😔 La próxima será...\n\n"
        message += "🏆 Top 5 Puntajes:\n"
        
        for (index, entry) in topScores.prefix(5).enumerated() {
            let user = entry["user"] as? String ?? "Usuario"
            let score = entry["score"] as? Int ?? 0
            message += "\(index + 1). \(user): \(score) puntos\n"
        }
        
        let alert = UIAlertController(title: "¡Juego terminado!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func cancelGame() {
        timer?.invalidate()
        moveTimer?.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    func saveScore() -> Bool {
        var topScores = UserDefaults.standard.array(forKey: "topScores") as? [[String: Any]] ?? []
        
        if let existingIndex = topScores.firstIndex(where: { $0["user"] as? String == username }) {
            if let existingScore = topScores[existingIndex]["score"] as? Int, score > existingScore {
                topScores[existingIndex]["score"] = score
            }
        } else {
            topScores.append(["user": username, "score": score])
        }
        
        topScores.sort { ($0["score"] as? Int ?? 0) > ($1["score"] as? Int ?? 0) }
        
        if topScores.count > 5 {
            topScores = Array(topScores.prefix(5))
        }
        
        UserDefaults.standard.setValue(topScores, forKey: "topScores")
        return topScores.contains { ($0["user"] as? String == username) }
    }
}

