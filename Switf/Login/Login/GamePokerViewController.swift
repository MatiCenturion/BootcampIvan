//
//  GamePokerViewController.swift
//  Login
//
//  Created by bootcamp on 2025-03-05.
//


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
        // Reparte cartas al jugador 1 y las elimina del mazo
        let cartasJugador1 = elegirCartasAlAzar()
        
        // Reparte cartas al jugador 2 sin incluir las del jugador 1
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
        let ganador = compararJugadas(jugada1: jugadaJugador1, jugada2: jugadaJugador2, cartas1: cartasJugador1, cartas2: cartasJugador2)
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
        
        for _ in 0..<5 {
            if let carta = mazo.first {
                cartasSeleccionadas.append(carta)
                mazo.removeFirst() // Elimina la carta seleccionada del mazo
            }
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
    
   

    private func compararJugadas(jugada1: String, jugada2: String, cartas1: [String], cartas2: [String]) -> String {
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
            return desempatar(jugada: jugada1, cartas1: cartas1, cartas2: cartas2)
        }
    }
    private func contarFrecuencia(_ numeros: [Int]) -> [Int: Int] {
        var freq = [Int: Int]()
        for num in numeros {
            freq[num, default: 0] += 1
        }
        return freq
    }
    
    private func desempatar(jugada: String, cartas1: [String], cartas2: [String]) -> String {
        // Extraemos los valores (sin el palo) y convertimos a enteros
        let valores1 = cartas1.map { String($0.prefix($0.count - 1)) }
        let valores2 = cartas2.map { String($0.prefix($0.count - 1)) }
        
        let numeros1 = valores1.compactMap { obtenerValorEntero($0) }
        let numeros2 = valores2.compactMap { obtenerValorEntero($0) }
        
        switch jugada {
        case "Escalera", "Escalera Color":
            // Se compara la carta más alta
            let max1 = numeros1.max() ?? 0
            let max2 = numeros2.max() ?? 0
            if max1 > max2 { return "Jugador 1" }
            else if max2 > max1 { return "Jugador 2" }
            else { return "Empate" }
            
        case "Poker":
            // Primero se compara el valor de las 4 cartas iguales, luego la quinta carta (kicker)
            let freq1 = contarFrecuencia(numeros1)
            let freq2 = contarFrecuencia(numeros2)
            let four1 = freq1.first(where: { $0.value == 4 })?.key ?? 0
            let four2 = freq2.first(where: { $0.value == 4 })?.key ?? 0
            if four1 != four2 {
                return four1 > four2 ? "Jugador 1" : "Jugador 2"
            }
            // Comparamos la carta restante (kicker)
            let kicker1 = freq1.first(where: { $0.value == 1 })?.key ?? 0
            let kicker2 = freq2.first(where: { $0.value == 1 })?.key ?? 0
            if kicker1 != kicker2 {
                return kicker1 > kicker2 ? "Jugador 1" : "Jugador 2"
            }
            return "Empate"
            
        case "Full":
            // Se compara primero el trío y luego el par
            let freq1 = contarFrecuencia(numeros1)
            let freq2 = contarFrecuencia(numeros2)
            let triple1 = freq1.first(where: { $0.value == 3 })?.key ?? 0
            let triple2 = freq2.first(where: { $0.value == 3 })?.key ?? 0
            if triple1 != triple2 {
                return triple1 > triple2 ? "Jugador 1" : "Jugador 2"
            }
            let pair1 = freq1.first(where: { $0.value == 2 })?.key ?? 0
            let pair2 = freq2.first(where: { $0.value == 2 })?.key ?? 0
            if pair1 != pair2 {
                return pair1 > pair2 ? "Jugador 1" : "Jugador 2"
            }
            return "Empate"
            
        case "Trío":
            // Se compara el valor del trío y luego las cartas restantes en orden descendente
            let freq1 = contarFrecuencia(numeros1)
            let freq2 = contarFrecuencia(numeros2)
            let trio1 = freq1.first(where: { $0.value == 3 })?.key ?? 0
            let trio2 = freq2.first(where: { $0.value == 3 })?.key ?? 0
            if trio1 != trio2 {
                return trio1 > trio2 ? "Jugador 1" : "Jugador 2"
            }
            // Obtener kickers y ordenarlos de mayor a menor
            let kickers1 = numeros1.filter { $0 != trio1 }.sorted(by: >)
            let kickers2 = numeros2.filter { $0 != trio2 }.sorted(by: >)
            for (k1, k2) in zip(kickers1, kickers2) {
                if k1 != k2 {
                    return k1 > k2 ? "Jugador 1" : "Jugador 2"
                }
            }
            return "Empate"
            
        case "Par Doble":
            // Se comparan primero el par más alto, luego el segundo par y finalmente la carta restante
            let freq1 = contarFrecuencia(numeros1)
            let freq2 = contarFrecuencia(numeros2)
            let pairs1 = freq1.filter { $0.value == 2 }.map { $0.key }.sorted(by: >)
            let pairs2 = freq2.filter { $0.value == 2 }.map { $0.key }.sorted(by: >)
            if pairs1.count == 2 && pairs2.count == 2 {
                if pairs1[0] != pairs2[0] {
                    return pairs1[0] > pairs2[0] ? "Jugador 1" : "Jugador 2"
                }
                if pairs1[1] != pairs2[1] {
                    return pairs1[1] > pairs2[1] ? "Jugador 1" : "Jugador 2"
                }
            }
            // Compara la carta restante (kicker)
            let kicker1 = freq1.first(where: { $0.value == 1 })?.key ?? 0
            let kicker2 = freq2.first(where: { $0.value == 1 })?.key ?? 0
            if kicker1 != kicker2 {
                return kicker1 > kicker2 ? "Jugador 1" : "Jugador 2"
            }
            return "Empate"
            
        case "Par":
            // Se compara el valor del par y luego las tres cartas restantes en orden descendente
            let freq1 = contarFrecuencia(numeros1)
            let freq2 = contarFrecuencia(numeros2)
            let pair1 = freq1.first(where: { $0.value == 2 })?.key ?? 0
            let pair2 = freq2.first(where: { $0.value == 2 })?.key ?? 0
            if pair1 != pair2 {
                return pair1 > pair2 ? "Jugador 1" : "Jugador 2"
            }
            // Obtenemos los kickers
            let kickers1 = numeros1.filter { $0 != pair1 }.sorted(by: >)
            let kickers2 = numeros2.filter { $0 != pair2 }.sorted(by: >)
            for (k1, k2) in zip(kickers1, kickers2) {
                if k1 != k2 {
                    return k1 > k2 ? "Jugador 1" : "Jugador 2"
                }
            }
            return "Empate"
            
        case "Color", "Carta Alta":
            // Se comparan todas las cartas en orden descendente
            let sorted1 = numeros1.sorted(by: >)
            let sorted2 = numeros2.sorted(by: >)
            for (v1, v2) in zip(sorted1, sorted2) {
                if v1 != v2 {
                    return v1 > v2 ? "Jugador 1" : "Jugador 2"
                }
            }
            return "Empate"
            
        default:
            return "Empate"
        }
    }
}
