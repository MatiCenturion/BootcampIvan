//
//  main.swift
//  Juego2Jugadores
//
//  Created by bootcamp on 2025-02-21.
//
import Foundation

var pilaA: Int = 5
var pilaB: Int = 5
var pilaC: Int = 5
var turno: Int = 0
var ganador: String = ""

// Solicitar al jugador 1 que ingrese su nombre
print("Jugador 1, ingrese su nombre: ")
let jugador1 = readLine() ?? "Invitado"

// Solicitar al jugador 2 que ingrese su nombre
print("Jugador 2, ingrese su nombre: ")
let jugador2 = readLine() ?? "Invitado"

while pilaA != 0 || pilaB != 0 || pilaC != 0 {
    var pilaElegida: String = ""
    
    if turno == 0 {
        // Mostrar la cantidad de pilas
        print("\(jugador1), elija una Pila (A, B, C): ")
        pilaElegida = readLine()?.uppercased() ?? "" // Leer la elección como String y convertir a mayúsculas
        
        if pilaElegida != "A" && pilaElegida != "B" && pilaElegida != "C" {
            print("Pila inválida. Elija 'A', 'B' o 'C'.")
            continue // Volver a pedir la elección si es inválida
        }
        turno = 1
    } else {
        print("\(jugador2), elija una Pila (A, B, C): ")
        pilaElegida = readLine()?.uppercased() ?? "" // Leer la elección como String y convertir a mayúsculas
        
        if pilaElegida != "A" && pilaElegida != "B" && pilaElegida != "C" {
            print("Pila inválida. Elija 'A', 'B' o 'C'.")
            continue // Volver a pedir la elección si es inválida
        }
        turno = 0
    }

    // Solicitar la cantidad a quitar de la pila
    print("¿Cuántos quitará de la pila? (ingresa un número): ")
    if let cantidad_a_quitar = Int(readLine() ?? "") {
        // Restar la cantidad de la pila elegida
        switch pilaElegida {
        case "A":
            if cantidad_a_quitar <= pilaA {
                pilaA -= cantidad_a_quitar
            } else {
                print("No hay suficientes elementos en la Pila A.")
            }
        case "B":
            if cantidad_a_quitar <= pilaB {
                pilaB -= cantidad_a_quitar
            } else {
                print("No hay suficientes elementos en la Pila B.")
            }
        case "C":
            if cantidad_a_quitar <= pilaC {
                pilaC -= cantidad_a_quitar
            } else {
                print("No hay suficientes elementos en la Pila C.")
            }
        default:
            print("Opción inválida.")
        }
    } else {
        print("Cantidad inválida, por favor ingresa un número.")
    }
    
    // Mostrar el estado final de las pilas
    print("Pila A: \(pilaA) Pila B: \(pilaB) Pila C: \(pilaC)")
    
//    Actualiza la variable ganador al ultimo jugador
    if turno == 0 {
        ganador = jugador1
    } else {
        ganador = jugador2
    }
}

// Fin del juego, todas las pilas están vacías
print("\(ganador), ya no quedan contadores, asi que... Ganaste!") 
