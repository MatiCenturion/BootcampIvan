//
//  GameDadosViewController.swift
//  Login
//
//  Created by bootcamp on 2025-03-04.
//

import UIKit

class GameDadosViewController: UIViewController {
    
    // Conectar los elementos desde el Storyboard
    @IBOutlet weak var resultadoLabel: UILabel!
    @IBOutlet weak var lanzarButton: UIButton!
    @IBOutlet var dadosImageViews: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultadoLabel.text = "Presiona 'Lanzar' para jugar"
    }


    @IBAction func lanzarDados(_ sender: UIButton) {
        var dados: [Int] = []
        
        for (index, imageView) in dadosImageViews.enumerated() {
            let numero = Int.random(in: 1...6)
            dados.append(numero)
            
            // Animación de rebote en los dados
            UIView.animate(withDuration: 0.1,
                           delay: Double(index) * 0.05,
                           options: [.curveEaseInOut],
                           animations: {
                imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                imageView.image = UIImage(named: "dado\(numero)")
                UIView.animate(withDuration: 0.2, animations: {
                    imageView.transform = .identity
                })
            }
        }
        
        let resultado = evaluarJugada(dados: dados)
        var nuevoColor: UIColor = .white
        switch resultado {
        case "¡Generala!":
            nuevoColor = .yellow
        case "¡Poker!":
            nuevoColor = .orange
        case "¡Full!":
            nuevoColor = .purple
        case "¡Escalera!":
            nuevoColor = .blue
        default:
            nuevoColor = .lightGray
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.resultadoLabel.alpha = 0
            self.resultadoLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.resultadoLabel.text = resultado
            self.resultadoLabel.textColor = nuevoColor
            self.resultadoLabel.font = UIFont(name: "MarkerFelt-Wide", size: 36) // Nueva fuente animada

            UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseOut], animations: {
                self.resultadoLabel.alpha = 1
                self.resultadoLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                // Rebote final para el efecto animado
                UIView.animate(withDuration: 0.2) {
                    self.resultadoLabel.transform = .identity
                }
            }
        }
    }
    
//    Para probar en duro
  /*  @IBAction func lanzarDados(_ sender: UIButton) {
        let dados = [6, 6, 6, 5, 5]  // Cambia los valores aquí para probar otro caso
        
        for (index, imageView) in dadosImageViews.enumerated() {
            let numero = dados[index] // Usar los valores fijos
            imageView.image = UIImage(named: "dado\(numero)")
            
            // Efecto rebote en la imagen
            UIView.animate(withDuration: 0.1, delay: Double(index) * 0.05, options: [.curveEaseInOut], animations: {
                imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    imageView.transform = .identity
                }
            }
        }
        
        // Evaluar el resultado y mostrarlo
        let resultado = evaluarJugada(dados: dados)
        resultadoLabel.text = resultado
    }*/


    private func evaluarJugada(dados: [Int]) -> String {
        let conteo = Dictionary(grouping: dados, by: { $0 }).mapValues { $0.count }
        print(conteo)
        if conteo.values.contains(5) { return "¡Generala!" }
        if conteo.values.contains(4) { return "¡Poker!" }
        if conteo.values.contains(3) && conteo.values.contains(2) { return "¡Full!" }
        if Set(dados).sorted() == [1,2,3,4,5] || Set(dados).sorted() == [2,3,4,5,6] {
            return "¡Escalera!"
        }
        return "Nada"
    }
}
