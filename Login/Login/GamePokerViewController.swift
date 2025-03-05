//
//  GamePokerViewController.swift
//  Login
//
//  Created by bootcamp on 2025-03-05.
//
/*
import UIKit

class GamePokerViewController: UIViewController {
        
    @IBOutlet weak var carta1ImageView: UIImageView!
    @IBOutlet weak var carta2ImageView: UIImageView!
    @IBOutlet weak var carta3ImageView: UIImageView!
    @IBOutlet weak var carta4ImageView: UIImageView!
    @IBOutlet weak var carta5ImageView: UIImageView!

    
    var valor: [String: [Int]] = [:]
    var poker = ["S", "C", "H", "D"]
    var mazo: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inicializarValores()
        crearMazo()
        let cartasAlAzar = elegirCartasAlAzar()
        print("Cartas seleccionadas: \(cartasAlAzar)")
        mostrarCartasEnImageViews(cartas: cartasAlAzar)  // Muestra las cartas en los ImageViews
        let jugada = identificarJugada(cartas: cartasAlAzar)
        print("Jugada: \(jugada)")
    }

    
    private func inicializarValores() {
        for i in 2...9 {
            valor["\(i)"] = [i]
        }
        valor["A"] = [1, 14]
        valor["T"] = [10]
        valor["J"] = [11]
        valor["Q"] = [12]
        valor["K"] = [13]
    }
    
    // Crear el mazo con todas las combinaciones de valor y palo
    private func crearMazo() {
        for valorCarta in valor.keys {
            for palo in poker {
                let carta = "\(valorCarta)\(palo)"
                mazo.append(carta)
            }
        }
    }
    
    // Elegir 5 cartas aleatorias del mazo
    private func elegirCartasAlAzar() -> [String] {
        var cartasSeleccionadas: [String] = []
        mazo.shuffle()
        for i in 0..<5 {
            cartasSeleccionadas.append(mazo[i])
        }
        return cartasSeleccionadas
    }

    
    // Identificar la jugada de las 5 cartas
    private func identificarJugada(cartas: [String]) -> String {
        // Separar valores y palos
        let valores = cartas.map { String($0.prefix($0.count - 1)) } // Obtener solo el valor (sin el palo)
        let palos = cartas.map { String($0.suffix(1)) } // Obtener solo el palo
        
        let valorCount = contarValores(valores)
        let paloCount = contarPalos(palos)
        
        if esEscaleraColor(valores: valores, palos: palos) {
            return "Escalera Color"
        } else if esPoker(valorCount) {
            return "Poker"
        } else if esFull(valorCount) {
            return "Full"
        } else if esColor(paloCount: paloCount) {
            return "Color"
        } else if esEscalera(valores: valores) {
            return "Escalera"
        } else if esTrio(valorCount) {
            return "Trío"
        } else if esDoblePar(valorCount) {
            return "Par Doble"
        } else if esPar(valorCount) {
            return "Par"
        } else {
            return "Carta Alta"
        }
    }
    
    // Función para contar las ocurrencias de cada valor
    private func contarValores(_ valores: [String]) -> [String: Int] {
        var count = [String: Int]()
        for valor in valores {
            count[valor, default: 0] += 1
        }
        return count
    }
    
    // Función para contar las ocurrencias de cada palo
    private func contarPalos(_ palos: [String]) -> [String: Int] {
        var count = [String: Int]()
        for palo in palos {
            count[palo, default: 0] += 1
        }
        return count
    }
    
    // Función para verificar si es Escalera Color
    private func esEscaleraColor(valores: [String], palos: [String]) -> Bool {
        return esEscalera(valores: valores) && esColor(paloCount: contarPalos(palos))
    }
    
    // Función para verificar si es Escalera
    private func esEscalera(valores: [String]) -> Bool {
        let valoresOrdenados = valores.sorted { valor1, valor2 in
            return valor1 < valor2
        }
        
        var secuencia: [Int] = []
        
        for valor in valoresOrdenados {
            if let valorInt = obtenerValorEntero(valor) {
                secuencia.append(valorInt)
            }
        }
        
        // Comprobar si hay una secuencia continua de números
        return secuencia == Array(secuencia.first!..<secuencia.first!+5)
    }
    
    // Función para obtener el valor entero de una carta
    private func obtenerValorEntero(_ valor: String) -> Int? {
        switch valor {
        case "A": return 14
        case "K": return 13
        case "Q": return 12
        case "J": return 11
        case "T": return 10
        default: return Int(valor)
        }
    }
    
    // Función para verificar si es Color
    private func esColor(paloCount: [String: Int]) -> Bool {
        return paloCount.values.contains(5)
    }
    
    // Función para verificar si es Poker
    private func esPoker(_ valorCount: [String: Int]) -> Bool {
        return valorCount.values.contains(4)
    }
    
    // Función para verificar si es Full
    private func esFull(_ valorCount: [String: Int]) -> Bool {
        return valorCount.values.contains(3) && valorCount.values.contains(2)
    }
    
    // Función para verificar si es Trío
    private func esTrio(_ valorCount: [String: Int]) -> Bool {
        return valorCount.values.contains(3)
    }
    
    // Función para verificar si es Doble Par
    private func esDoblePar(_ valorCount: [String: Int]) -> Bool {
        return valorCount.values.filter { $0 == 2 }.count == 2
    }
    
    // Función para verificar si es Par
    private func esPar(_ valorCount: [String: Int]) -> Bool {
        return valorCount.values.contains(2)
    }
    
    private func mostrarCartasEnImageViews(cartas: [String]) {
        let imageViews = [carta1ImageView, carta2ImageView, carta3ImageView, carta4ImageView, carta5ImageView]
        
        for (index, carta) in cartas.enumerated() {
            let nombreImagen = carta // Este es el nombre de la carta que se corresponde con el nombre de la imagen en los Assets
            if let imageView = imageViews[index] {
                imageView.image = UIImage(named: nombreImagen)
            }
        }
    }

    
}*/

import UIKit

class GamePokerViewController: UIViewController {
    
    // Imágenes para jugador 1
    @IBOutlet weak var carta1ImageView: UIImageView!
    @IBOutlet weak var carta2ImageView: UIImageView!
    @IBOutlet weak var carta3ImageView: UIImageView!
    @IBOutlet weak var carta4ImageView: UIImageView!
    @IBOutlet weak var carta5ImageView: UIImageView!
    
    // Imágenes para jugador 2
    @IBOutlet weak var carta6ImageView: UIImageView!
    @IBOutlet weak var carta7ImageView: UIImageView!
    @IBOutlet weak var carta8ImageView: UIImageView!
    @IBOutlet weak var carta9ImageView: UIImageView!
    @IBOutlet weak var carta10ImageView: UIImageView!
    
    // Labels para mostrar las jugadas de cada jugador
    @IBOutlet weak var jugador1JugadaLabel: UILabel!
    @IBOutlet weak var jugador2JugadaLabel: UILabel!
    
    var valor: [String: [Int]] = [:]
    var poker = ["S", "C", "H", "D"]
    var mazo: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inicializarValores()
        crearMazo()
    }
    
    @IBAction func repartirCartasButtonTapped(_ sender: UIButton) {
        let cartasJugador1 = elegirCartasAlAzar()
        let cartasJugador2 = elegirCartasAlAzar()
        
        print("Cartas Jugador 1: \(cartasJugador1)")
        print("Cartas Jugador 2: \(cartasJugador2)")
        
        // Mostrar las cartas en las ImageViews de ambos jugadores
        mostrarCartasEnImageViews(cartas: cartasJugador1, jugador: 1)
        mostrarCartasEnImageViews(cartas: cartasJugador2, jugador: 2)
        
        // Identificar las jugadas de ambos jugadores
        let jugadaJugador1 = identificarJugada(cartas: cartasJugador1)
        let jugadaJugador2 = identificarJugada(cartas: cartasJugador2)
        
        // Mostrar las jugadas en las labels
        jugador1JugadaLabel.text = "Jugada Jugador 1: \(jugadaJugador1)"
        jugador2JugadaLabel.text = "Jugada Jugador 2: \(jugadaJugador2)"
        
        // Comparar las jugadas y determinar el ganador
        let ganador = compararJugadas(jugada1: jugadaJugador1, jugada2: jugadaJugador2)
        print("El ganador es: \(ganador)")
    }

    private func inicializarValores() {
        for i in 2...9 {
            valor["\(i)"] = [i]
        }
        valor["A"] = [1, 14]
        valor["T"] = [10]
        valor["J"] = [11]
        valor["Q"] = [12]
        valor["K"] = [13]
    }
    
    private func crearMazo() {
        for valorCarta in valor.keys {
            for palo in poker {
                let carta = "\(valorCarta)\(palo)"
                mazo.append(carta)
            }
        }
    }
    
    private func elegirCartasAlAzar() -> [String] {
        var cartasSeleccionadas: [String] = []
        mazo.shuffle()
        for i in 0..<5 {
            cartasSeleccionadas.append(mazo[i])
        }
        return cartasSeleccionadas
    }
    
    private func identificarJugada(cartas: [String]) -> String {
        let valores = cartas.map { String($0.prefix($0.count - 1)) }
        let palos = cartas.map { String($0.suffix(1)) }
        
        let valorCount = contarValores(valores)
        let paloCount = contarPalos(palos)
        
        if esEscaleraColor(valores: valores, palos: palos) {
            return "Escalera Color"
        } else if esPoker(valorCount) {
            return "Poker"
        } else if esFull(valorCount) {
            return "Full"
        } else if esColor(paloCount: paloCount) {
            return "Color"
        } else if esEscalera(valores: valores) {
            return "Escalera"
        } else if esTrio(valorCount) {
            return "Trío"
        } else if esDoblePar(valorCount) {
            return "Par Doble"
        } else if esPar(valorCount) {
            return "Par"
        } else {
            return "Carta Alta"
        }
    }

    private func contarValores(_ valores: [String]) -> [String: Int] {
        var count = [String: Int]()
        for valor in valores {
            count[valor, default: 0] += 1
        }
        return count
    }
    
    private func contarPalos(_ palos: [String]) -> [String: Int] {
        var count = [String: Int]()
        for palo in palos {
            count[palo, default: 0] += 1
        }
        return count
    }
    
    private func esEscaleraColor(valores: [String], palos: [String]) -> Bool {
        return esEscalera(valores: valores) && esColor(paloCount: contarPalos(palos))
    }
    
    private func esEscalera(valores: [String]) -> Bool {
        let valoresOrdenados = valores.sorted { valor1, valor2 in
            return valor1 < valor2
        }
        
        var secuencia: [Int] = []
        
        for valor in valoresOrdenados {
            if let valorInt = obtenerValorEntero(valor) {
                secuencia.append(valorInt)
            }
        }
        
        return secuencia == Array(secuencia.first!..<secuencia.first!+5)
    }
    
    private func obtenerValorEntero(_ valor: String) -> Int? {
        switch valor {
        case "A": return 14
        case "K": return 13
        case "Q": return 12
        case "J": return 11
        case "T": return 10
        default: return Int(valor)
        }
    }
    
    private func esColor(paloCount: [String: Int]) -> Bool {
        return paloCount.values.contains(5)
    }
    
    private func esPoker(_ valorCount: [String: Int]) -> Bool {
        return valorCount.values.contains(4)
    }
    
    private func esFull(_ valorCount: [String: Int]) -> Bool {
        return valorCount.values.contains(3) && valorCount.values.contains(2)
    }
    
    private func esTrio(_ valorCount: [String: Int]) -> Bool {
        return valorCount.values.contains(3)
    }
    
    private func esDoblePar(_ valorCount: [String: Int]) -> Bool {
        return valorCount.values.filter { $0 == 2 }.count == 2
    }
    
    private func esPar(_ valorCount: [String: Int]) -> Bool {
        return valorCount.values.contains(2)
    }
    
    
    private func mostrarCartasEnImageViews(cartas: [String], jugador: Int) {
        let imageViews: [UIImageView]
        
        if jugador == 1 {
            imageViews = [carta1ImageView, carta2ImageView, carta3ImageView, carta4ImageView, carta5ImageView]
        } else {
            imageViews = [carta6ImageView, carta7ImageView, carta8ImageView, carta9ImageView, carta10ImageView]
        }
        
        for (index, carta) in cartas.enumerated() {
            let nombreImagen = carta
            let imageView = imageViews[index]  // Accede directamente al UIImageView en la posición index
            imageView.image = UIImage(named: nombreImagen)
        }
    }


    private func compararJugadas(jugada1: String, jugada2: String) -> String {
        let rankingJugadas = [
            "Carta Alta": 1,
            "Par": 2,
            "Par Doble": 3,
            "Trío": 4,
            "Escalera": 5,
            "Color": 6,
            "Full": 7,
            "Poker": 8,
            "Escalera Color": 9
        ]
        
        let rank1 = rankingJugadas[jugada1] ?? 0
        let rank2 = rankingJugadas[jugada2] ?? 0
        
        if rank1 > rank2 {
            return "Jugador 1"
        } else if rank2 > rank1 {
            return "Jugador 2"
        } else {
            return "Empate"
        }
    }
}

