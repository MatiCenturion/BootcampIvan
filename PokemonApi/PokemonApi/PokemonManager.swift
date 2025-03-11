//
//  PokemonManager.swift
//  PokemonApi
//
//  Created by bootcamp on 2025-03-10.
//

import Foundation // Importa Foundation para funcionalidades básicas

// Clase encargada de gestionar las solicitudes de datos de Pokémon desde la PokeAPI
class PokemonManager {
    
    // Obtiene los datos de un Pokémon a partir de su nombre
    func fetchPokemonData(pokemonName: String, completion: @escaping (Pokemon?, String?) -> Void) {
        let endpoint = "https://pokeapi.co/api/v2/pokemon/\(pokemonName.lowercased())" // Construye la URL usando el nombre en minúsculas
        
        HTTPClient.request(
            endpoint: endpoint, // URL de la solicitud
            method: .get, // Método HTTP GET
            encoding: .json, // Se espera una respuesta en formato JSON
            headers: nil, // No se agregan encabezados adicionales
            onSuccess: { (pokemon: Pokemon) in // Maneja la respuesta exitosa parseándola a la estructura Pokemon
                // Obtiene la descripción del Pokémon a partir de la URL de su especie
                self.fetchPokemonDescription(speciesURL: pokemon.species.url, completion: { description in
                    completion(pokemon, description) // Retorna los datos del Pokémon y su descripción
                })
            },
            onFailure: { error in // Maneja el fallo de la solicitud
                print("Error: \(error.message)") // Imprime el error en la consola
                completion(nil, nil) // Retorna nil en caso de error
            }
        )
    }
    
    // Obtiene la descripción del Pokémon desde la URL de su especie
    func fetchPokemonDescription(speciesURL: String, completion: @escaping (String?) -> Void) {
        HTTPClient.request(
            endpoint: speciesURL, // URL de la especie del Pokémon
            method: .get, // Método HTTP GET
            encoding: .json, // Se espera JSON en la respuesta
            headers: nil, // No se agregan encabezados adicionales
            onSuccess: { (speciesData: PokemonSpecies) in // Maneja la respuesta exitosa parseándola a PokemonSpecies
                // Busca la primera descripción en español o, de no existir, la primera disponible
                if let descriptionEntry = speciesData.flavor_text_entries.first(where: { $0.language.name == "es" }) {
                    completion(descriptionEntry.flavor_text) // Retorna la descripción en español
                } else {
                    completion(speciesData.flavor_text_entries.first?.flavor_text) // Retorna la primera descripción disponible
                }
            },
            onFailure: { error in // Maneja el fallo de la solicitud
                print("Error: \(error.message)") // Imprime el error en la consola
                completion(nil) // Retorna nil en caso de error
            }
        )
    }
    
    // Obtiene una lista de nombres de todos los Pokémon disponibles en la API
    func fetchPokemonList(completion: @escaping ([String]?) -> Void) {
        let endpoint = "https://pokeapi.co/api/v2/pokemon?limit=10025" // URL que solicita la lista completa de Pokémon
        
        HTTPClient.request(
            endpoint: endpoint, // URL de la solicitud
            method: .get, // Método HTTP GET
            encoding: .json, // Se espera una respuesta en JSON
            headers: nil, // No se agregan encabezados adicionales
            onSuccess: { (data: PokemonListResponse) in // Maneja la respuesta exitosa parseándola a PokemonListResponse
                let pokemonNames = data.results.map { $0.name } // Extrae y mapea los nombres de cada Pokémon
                completion(pokemonNames) // Retorna la lista de nombres
            },
            onFailure: { error in // Maneja el fallo de la solicitud
                completion(nil) // Retorna nil en caso de error
            }
        )
    }
    
    // Obtiene los datos de un Pokémon a partir de su número (ID)
    func fetchPokemonDataByNumber(pokemonNumber: Int, completion: @escaping (Pokemon?, String?) -> Void) {
        let endpoint = "https://pokeapi.co/api/v2/pokemon/\(pokemonNumber)" // Construye la URL usando el número del Pokémon
        
        HTTPClient.request(
            endpoint: endpoint, // URL de la solicitud
            method: .get, // Método HTTP GET
            encoding: .json, // Se espera una respuesta en JSON
            headers: nil, // No se agregan encabezados adicionales
            onSuccess: { (pokemon: Pokemon) in // Maneja la respuesta exitosa parseándola a Pokemon
                // Obtiene la descripción del Pokémon usando la URL de su especie
                self.fetchPokemonDescription(speciesURL: pokemon.species.url, completion: { description in
                    completion(pokemon, description) // Retorna los datos del Pokémon y su descripción
                })
            },
            onFailure: { error in // Maneja el fallo de la solicitud
                print("Error: \(error.message)") // Imprime el error en la consola
                completion(nil, "Error: \(error.message)") // Retorna nil junto con el mensaje de error
            }
        )
    }
    
    // Extrae el número de un Pokémon a partir de su URL
    func extractPokemonNumber(from urlString: String) -> Int? {
        let components = urlString.split(separator: "/") // Separa la URL en componentes usando "/" como delimitador
        
        if let numberString = components.dropLast().last, // Obtiene la penúltima parte que corresponde al número
           let number = Int(numberString) { // Intenta convertirla a entero
            return number // Retorna el número extraído
        }
        return nil // Retorna nil si no se pudo extraer el número
    }
    
    // NUEVA FUNCIÓN: Obtiene una lista de nombres de Pokémon filtrados por tipo
    func fetchPokemonListByType(type: String, completion: @escaping ([String]?) -> Void) {
        let endpoint = "https://pokeapi.co/api/v2/type/\(type)" // Construye la URL usando el tipo en inglés
        
        HTTPClient.request(
            endpoint: endpoint, // URL de la solicitud
            method: .get, // Método HTTP GET
            encoding: .json, // Se espera una respuesta en JSON
            headers: nil, // No se agregan encabezados adicionales
            onSuccess: { (response: PokemonTypeResponse) in // Maneja la respuesta exitosa parseándola a PokemonTypeResponse
                let pokemonNames = response.pokemon.map { $0.pokemon.name } // Extrae los nombres de los Pokémon del tipo
                completion(pokemonNames) // Retorna la lista de nombres
            },
            onFailure: { error in // Maneja el fallo de la solicitud
                print("Error al obtener Pokémon por tipo: \(error.message)") // Imprime el error en la consola
                completion(nil) // Retorna nil en caso de error
            }
        )
    }
}

