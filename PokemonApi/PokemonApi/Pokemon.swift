//
//  Pokemon.swift
//  PokemonApi
//
//  Created by bootcamp on 2025-03-10.
//


import Foundation

// Estructura principal que representa un Pokémon
struct Pokemon: Codable {
    let name: String // Nombre del Pokémon
    let sprites: Sprites // Imágenes asociadas al Pokémon
    let types: [PokemonTypeEntry] // Lista de tipos del Pokémon
    let species: PokemonSpeciesReference // Referencia a la especie del Pokémon
}

// Estructura que referencia la especie del Pokémon mediante una URL
struct PokemonSpeciesReference: Codable {
    let url: String // URL con información adicional sobre la especie
}

// Estructura que contiene las imágenes del Pokémon
struct Sprites: Codable {
    let front_default: String? // Imagen por defecto del Pokémon
    let other: OtherSprites // Otras variantes de imágenes
    
    private enum CodingKeys: String, CodingKey {
        case front_default, other
    }
}

// Estructura que almacena imágenes adicionales del Pokémon
struct OtherSprites: Codable {
    let officialArtwork: OfficialArtwork // Imagen oficial del Pokémon
    
    private enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

// Estructura que contiene la imagen oficial del Pokémon
struct OfficialArtwork: Codable {
    let frontDefault: String // URL de la imagen oficial del Pokémon
    
    private enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// Estructura que representa una entrada de tipo de Pokémon
struct PokemonTypeEntry: Codable {
    let type: PokemonType // Tipo específico del Pokémon
}

// Estructura que define un tipo de Pokémon
struct PokemonType: Codable {
    let name: String // Nombre del tipo (ejemplo: fuego, agua, planta)
}

// Estructura que almacena la información de la especie del Pokémon, incluyendo descripciones
struct PokemonSpecies: Decodable {
    let flavor_text_entries: [FlavorTextEntry] // Lista de descripciones en diferentes idiomas
}

// Estructura que representa una entrada de texto descriptivo del Pokémon
struct FlavorTextEntry: Codable {
    let flavor_text: String // Descripción del Pokémon
    let language: Language // Idioma en el que está escrita la descripción
}

// Estructura que define el idioma de una descripción
struct Language: Codable {
    let name: String // Nombre del idioma (ejemplo: "es" para español, "en" para inglés)
}

// Estructura que representa la respuesta de la API con la lista de Pokémon
struct PokemonListResponse: Decodable {
    let results: [PokemonResult] // Lista de resultados de Pokémon
}

// Estructura que almacena información básica de un Pokémon en la lista
struct PokemonResult: Decodable {
    let name: String // Nombre del Pokémon
    let url: String // URL con más detalles sobre el Pokémon
}

// Enumeración que define los métodos HTTP disponibles
enum HTTPMethod: String {
    case get = "GET" // Método GET para solicitudes HTTP
}

// Enumeración que define los tipos de codificación para las solicitudes HTTP
enum HTTPEncoding {
    case json // Codificación en formato JSON
}

// Estructura que representa un error en las solicitudes HTTP
struct HTTPError: Error {
    let message: String // Mensaje descriptivo del error
}

// Cliente HTTP para realizar solicitudes a la API
struct HTTPClient {
    static func request<T: Decodable>(
        endpoint: String, // URL de la solicitud
        method: HTTPMethod, // Método HTTP (ejemplo: GET)
        encoding: HTTPEncoding, // Tipo de codificación de la solicitud
        headers: [String: String]?, // Encabezados HTTP opcionales
        onSuccess: @escaping (T) -> Void, // Callback en caso de éxito
        onFailure: @escaping (HTTPError) -> Void // Callback en caso de error
    ) {
        // Verificar que la URL sea válida
        guard let url = URL(string: endpoint) else {
            onFailure(HTTPError(message: "URL inválida"))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue // Establecer método HTTP
        
        // Agregar encabezados si existen
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Configurar encoding: si es JSON, establecer Content-Type
        if encoding == .json {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // Crear la tarea de red
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
        task.resume() // Iniciar la solicitud HTTP
    }
}

// Estructura que representa la respuesta de la API para un tipo de Pokémon
struct PokemonTypeResponse: Decodable {
    let pokemon: [PokemonTypeEntryResponse] // Lista de entradas de Pokémon correspondientes a este tipo
}

// Estructura que representa cada entrada de Pokémon en la respuesta de tipo
struct PokemonTypeEntryResponse: Decodable {
    let pokemon: PokemonResult // Contiene la información básica del Pokémon (nombre y URL)
}
