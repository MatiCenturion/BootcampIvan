//
//  Pokemon.swift
//  PokemonApi
//
//  Created by bootcamp on 2025-03-10.
//

import Foundation

// Estructura principal del Pokémon
struct Pokemon: Codable {
    let name: String
    let sprites: Sprites
    let types: [PokemonTypeEntry]
    let species: PokemonSpeciesReference
}

// Referencia a la especie (contiene la URL)
struct PokemonSpeciesReference: Codable {
    let url: String
}

// Estructura de las imágenes del Pokémon con anidamiento
struct Sprites: Codable {
    let front_default: String?
    let other: OtherSprites
    
    private enum CodingKeys: String, CodingKey {
        case front_default, other
    }
}

struct OtherSprites: Codable {
    let officialArtwork: OfficialArtwork
    
    private enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let frontDefault: String
    
    private enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// Tipos de Pokémon
struct PokemonTypeEntry: Codable {
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

// Estructura para la descripción del Pokémon
struct PokemonSpecies: Decodable {
    let flavor_text_entries: [FlavorTextEntry]
}

struct FlavorTextEntry: Codable {
    let flavor_text: String
    let language: Language
}

struct Language: Codable {
    let name: String
}

// Estructura para la lista de Pokémon
struct PokemonListResponse: Decodable {
    let results: [PokemonResult]
}

struct PokemonResult: Decodable {
    let name: String
    let url: String
}


enum HTTPMethod: String {
    case get = "GET"
    // Agrega otros métodos HTTP si los necesitas
}

enum HTTPEncoding {
    case json
    // Agrega otros tipos de encoding si es necesario
}

struct HTTPError: Error {
    let message: String
}

struct HTTPClient {
    static func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        encoding: HTTPEncoding,
        headers: [String: String]?,
        onSuccess: @escaping (T) -> Void,
        onFailure: @escaping (HTTPError) -> Void
    ) {
        guard let url = URL(string: endpoint) else {
            onFailure(HTTPError(message: "URL inválida"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Agregar headers si existen
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Configurar encoding: si es JSON, establecer Content-Type
        if encoding == .json {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                onFailure(HTTPError(message: error.localizedDescription))
                return
            }
            
            guard let data = data else {
                onFailure(HTTPError(message: "No se recibieron datos"))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                onSuccess(decodedData)
            } catch {
                onFailure(HTTPError(message: "Error al parsear datos: \(error.localizedDescription)"))
            }
        }
        task.resume()
    }
}

