//
//  Pokemon.swift
//  pruebaApi
//
//  Created by bootcamp on 2025-03-07.
//

import Foundation

// Estructura principal del Pokémon
struct Pokemon: Codable {
    let name: String
    let sprites: Sprites
    let types: [PokemonTypeEntry]
    let species: PokemonSpeciesReference // Cambiar a la estructura correcta
}
    

// Estructura para obtener la referencia a la especie (contiene la URL)
struct PokemonSpeciesReference: Codable {
    let url: String
}



// Estructura para obtener la imagen del Pokémon
struct Sprites: Codable {
    let front_default: String
}

// Estructura para obtener los tipos del Pokémon
struct PokemonTypeEntry: Codable {
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

// Estructura para obtener la descripción del Pokémon
// Estructura para obtener la descripción del Pokémon
struct PokemonSpecies: Decodable {
    let flavor_text_entries: [FlavorTextEntry]
}


// Estructura para la descripción del Pokémon (requiere otra petición a la API)
struct PokemonDescription: Codable {
    let flavor_text_entries: [FlavorTextEntry]
}

struct FlavorTextEntry: Codable {
    let flavor_text: String
    let language: Language
}

struct Language: Codable {
    let name: String
}
/*
struct PokemonListResponse: Codable { // Cambié de 'Decodable' a 'Codable'
    let results: [PokemonResult]
}*/
struct PokemonListResponse: Decodable {
    let results: [PokemonResult]
}

struct PokemonResult: Decodable {
    let name: String
    let url: String // Agregado para extraer el número
}
/*

struct PokemonResult: Codable {
    let name: String
}*/
