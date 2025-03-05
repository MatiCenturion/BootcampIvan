//
//  GamePokerViewController.swift
//  Login
//
//  Created by bootcamp on 2025-03-05.
//
import UIKit

class GamePokerViewController: UIViewController {

    var valor: [String: [Int]] = [:]
    var poker = ["S", "C", "H", "D"]
    var mazo: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inicializarValores()
        crearMazo()
        let cartasAlAzar = elegirCartasAlAzar()
        print("Cartas seleccionadas: \(cartasAlAzar)")
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
}

