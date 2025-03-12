//
//  Pokemon.swift
//  PokemonApi
//
//  Created by bootcamp on 2025-03-10.
//
import Foundation

// MARK: - Modelos de Pokémon

struct Pokemon: Codable {
    let name: String
    let sprites: Sprites
    let types: [PokemonTypeEntry]
    let species: PokemonSpeciesReference
}

struct PokemonSpeciesReference: Codable {
    let url: String
}

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

struct PokemonTypeEntry: Codable {
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

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

struct PokemonListResponse: Decodable {
    let results: [PokemonResult]
}

struct PokemonResult: Decodable {
    let name: String
    let url: String
}

// MARK: - Section Model para agrupar Pokémon por tipo

struct PokemonSection {
    let typeName: String       // Ej: "Fuego"
    let englishType: String    // Ej: "fire"
    var pokemonNames: [String]
    var isExpanded: Bool
}

// MARK: - HTTP Client y Enums

enum HTTPMethod: String {
    case get = "GET"
}

enum HTTPEncoding {
    case json
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
        
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
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

struct PokemonTypeResponse: Decodable {
    let pokemon: [PokemonTypeEntryResponse]
}

struct PokemonTypeEntryResponse: Decodable {
    let pokemon: PokemonResult
}
