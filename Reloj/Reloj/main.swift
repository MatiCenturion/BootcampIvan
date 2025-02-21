//
//  main.swift
//  Reloj
//
//  Created by bootcamp on 2025-02-21.
//

import Foundation
//Creamos la clase con sus atributos
class Reloj {
    private var horas: Int
    private var minutos: Int
    private var segundos: Int
    
    //Inicializamos los valores de los atributos con el constructor
    init(horas: Int = 0, minutos: Int = 0, segundos: Int = 0) {
        self.horas = horas
        self.minutos = minutos
        self.segundos = segundos
    }
    
    //Funcion para configurar la hora en segundos desde medianoche
    func setReloj(segundosDesdeMedianoche: Int) {
        self.horas = segundosDesdeMedianoche / 3600
        self.minutos = (segundosDesdeMedianoche % 3600) / 60
        self.segundos = segundosDesdeMedianoche % 60
    }
    
    func getHoras() -> Int {
        return horas
    }
    
    func getMinutos() -> Int {
        return minutos
    }
    
    func getSegundos() -> Int {
        return segundos
    }
    
    func setHoras(horas: Int) {
        self.horas = horas
    }
    
    func setMinutos(minutos: Int) {
        self.minutos = minutos
    }
    
    func setSegundos(segundos: Int) {
        self.segundos = segundos
    }
    //Utilizamos el metodo tick que incrementa el tiempo en 1 segundo
    func tick() {
        self.segundos += 1
        if self.segundos == 60 {
            self.segundos = 0
            self.minutos += 1
            if self.minutos == 60 {
                self.minutos = 0
                self.horas += 1
                if self.horas == 24 {
                    self.horas = 0
                }
            }
        }
    }
    // Metodo tickDecrement() que decrementa el tiempo en 1 segundo
    func tickDecrement() {
        self.segundos -= 1
        if self.segundos < 0 {
            self.segundos = 59
            self.minutos -= 1
            if self.minutos < 0 {
                self.minutos = 59
                self.horas = -1
                if self.horas < 0 {
                    self.horas = 23
                }
            }
        }
    }
    //Metodo addReloj, que agrega un parametro de tipo reloj al reloj actual
    func addReloj(reloj: Reloj) {
        let segundosActuales = self.horas * 3600 + self.minutos * 60 + self.segundos * 60
        let segundosOtroReloj = reloj.getHoras() * 3600 + reloj.getMinutos() * 60 + reloj.getSegundos()
        let totalSegundos = segundosActuales + segundosOtroReloj
        
        setReloj(segundosDesdeMedianoche: totalSegundos)
    }
    
    //Metodo que retorna la hora en formato "[hh:mm:ss]"
    func toString() -> String {
        return String(format: "[%02d:%02d:%02d]", horas, minutos, segundos)
    }
}

let reloj1 = Reloj(horas: 5, minutos: 30, segundos: 0)
let reloj2 = Reloj(horas: 2, minutos: 45, segundos: 30)

// Mostrar los relojes
print(reloj1.toString()) // "[05:30:00]"
print(reloj2.toString()) // "[02:45:30]"

// Sumar los relojes
reloj1.addReloj(reloj: reloj2)
print(reloj1.toString()) // "[08:15:30]"

// Hacer un tick (incrementar 1 segundo)
reloj1.tick()
print(reloj1.toString()) // "[08:15:31]"

// Hacer un tickDecrement (decrementar 1 segundo)
reloj1.tickDecrement()
print(reloj1.toString()) // "[08:15:30]"

