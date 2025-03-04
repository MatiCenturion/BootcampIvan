//
//  GameDadosViewController.swift
//  Login
//
//  Created by bootcamp on 2025-03-04.
//
/*import UIKit

class GameDadosViewController: UIViewController {
    private var dados: [Int] = [1, 2, 3, 4, 5]
    private let resultadoLabel = UILabel()
    private let lanzarButton = UIButton()
    private var dadosImageViews: [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Generala"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        for _ in 1...5 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(systemName: "die.face.1.fill")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            stackView.addArrangedSubview(imageView)
            dadosImageViews.append(imageView)
        }
        
        resultadoLabel.font = UIFont.systemFont(ofSize: 24)
        resultadoLabel.textAlignment = .center
        resultadoLabel.text = "Presiona 'Lanzar' para jugar"
        resultadoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultadoLabel)
        
        lanzarButton.setTitle("Lanzar", for: .normal)
        lanzarButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        lanzarButton.backgroundColor = .blue
        lanzarButton.setTitleColor(.white, for: .normal)
        lanzarButton.layer.cornerRadius = 10
        lanzarButton.translatesAutoresizingMaskIntoConstraints = false
        lanzarButton.addTarget(self, action: #selector(lanzarDados), for: .touchUpInside)
        view.addSubview(lanzarButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            resultadoLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            resultadoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lanzarButton.topAnchor.constraint(equalTo: resultadoLabel.bottomAnchor, constant: 20),
            lanzarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lanzarButton.widthAnchor.constraint(equalToConstant: 150),
            lanzarButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc private func lanzarDados() {
        dados = (1...5).map { _ in Int.random(in: 1...6) }

        for (index, imageView) in dadosImageViews.enumerated() {
            let nuevoValor = dados[index]
            
            // Animación con rebote
            UIView.animate(withDuration: 0.3, delay: Double(index) * 0.1, options: [.curveEaseOut], animations: {
                imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).rotated(by: .pi / 6)
            }, completion: { _ in
                // Cambiar imagen después del primer efecto
                imageView.image = UIImage(systemName: "die.face.\(nuevoValor).fill")

                // Animación de rebote hacia atrás
                UIView.animate(withDuration: 0.2, animations: {
                    imageView.transform = .identity // Volver a su tamaño original
                })
            })
        }

        resultadoLabel.text = evaluarJugada(dados: dados)
    }


    private func evaluarJugada(dados: [Int]) -> String {
        let conteo = Dictionary(grouping: dados, by: { $0 }).mapValues { $0.count }
        
        if conteo.values.contains(5) {
            return "¡Generala!"
        } else if conteo.values.contains(4) {
            return "¡Poker!"
        } else if conteo.values.contains(3) && conteo.values.contains(2) {
            return "¡Full!"
        } else if Set(dados).sorted() == [1,2,3,4,5] || Set(dados).sorted() == [2,3,4,5,6] {
            return "¡Escalera!"
        } else {
            return "Nada"
        }
    }
}

*/
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

    /*@IBAction func lanzarDados(_ sender: UIButton) {
        var dados: [Int] = []
        
        for imageView in dadosImageViews {
            let numero = Int.random(in: 1...6)
            dados.append(numero)
            imageView.image = UIImage(named: "dado\(numero)")
        }
        
        resultadoLabel.text = evaluarJugada(dados: dados)
    }*/
    @IBAction func lanzarDados(_ sender: UIButton) {
        var dados: [Int] = []
        
        for (index, imageView) in dadosImageViews.enumerated() {
            let numero = Int.random(in: 1...6)
            dados.append(numero)
            
            // Animación de rebote
            UIView.animate(withDuration: 0.1,
                           delay: Double(index) * 0.05, // Pequeño retraso entre cada dado
                           options: [.curveEaseInOut],
                           animations: {
                imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2) // Se agranda un poco
            }) { _ in
                imageView.image = UIImage(named: "dado\(numero)")
                UIView.animate(withDuration: 0.2, animations: {
                    imageView.transform = .identity // Vuelve a su tamaño normal
                })
            }
        }
        
        resultadoLabel.text = evaluarJugada(dados: dados)
    }

    private func evaluarJugada(dados: [Int]) -> String {
        let conteo = Dictionary(grouping: dados, by: { $0 }).mapValues { $0.count }
        
        if conteo.values.contains(5) { return "¡Generala!" }
        if conteo.values.contains(4) { return "¡Poker!" }
        if conteo.values.contains(3) && conteo.values.contains(2) { return "¡Full!" }
        if Set(dados).sorted() == [1,2,3,4,5] || Set(dados).sorted() == [2,3,4,5,6] {
            return "¡Escalera!"
        }
        return "Nada"
    }
}
