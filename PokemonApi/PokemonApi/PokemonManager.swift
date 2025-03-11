//
//  PokemonManager.swift
//  PokemonApi
//
//  Created by bootcamp on 2025-03-10.
//

import Foundation

// Clase encargada de gestionar las solicitudes de datos de Pokémon desde la PokeAPI
class PokemonManager {
    
    // Obtiene los datos de un Pokémon a partir de su nombre
    func fetchPokemonData(pokemonName: String, completion: @escaping (Pokemon?, String?) -> Void) {
        let endpoint = "https://pokeapi.co/api/v2/pokemon/\(pokemonName.lowercased())"
        
        HTTPClient.request(
            endpoint: endpoint,
            method: .get,
            encoding: .json,
            headers: nil,
            onSuccess: { [weak self] (pokemon: Pokemon) in
                guard let self = self else { return }
                self.fetchPokemonDescription(speciesURL: pokemon.species.url) { description in
                    completion(pokemon, description)
                }
            },
            onFailure: { error in
                print("Error: \(error.message)")
                completion(nil, nil)
            }
        )
    }
    
    // Obtiene la descripción del Pokémon desde la URL de su especie
    func fetchPokemonDescription(speciesURL: String, completion: @escaping (String?) -> Void) {
        HTTPClient.request(
            endpoint: speciesURL,
            method: .get,
            encoding: .json,
            headers: nil,
            onSuccess: { (speciesData: PokemonSpecies) in
                let descriptionEntry = speciesData.flavor_text_entries.first(where: { $0.language.name == "es" }) ??
                                       speciesData.flavor_text_entries.first
                completion(descriptionEntry?.flavor_text)
            },
            onFailure: { error in
                print("Error: \(error.message)")
                completion(nil)
            }
        )
    }
    
    // Obtiene una lista de nombres de todos los Pokémon disponibles en la API
    func fetchPokemonList(completion: @escaping ([String]?) -> Void) {
        let endpoint = "https://pokeapi.co/api/v2/pokemon?limit=10025"
        
        HTTPClient.request(
            endpoint: endpoint,
            method: .get,
            encoding: .json,
            headers: nil,
            onSuccess: { (data: PokemonListResponse) in
                let pokemonNames = data.results.map { $0.name }
                completion(pokemonNames)
            },
            onFailure: { error in
                completion(nil)
            }
        )
    }
    
    // Obtiene los datos de un Pokémon a partir de su número (ID)
    func fetchPokemonDataByNumber(pokemonNumber: Int, completion: @escaping (Pokemon?, String?) -> Void) {
        let endpoint = "https://pokeapi.co/api/v2/pokemon/\(pokemonNumber)"
        
        HTTPClient.request(
            endpoint: endpoint,
            method: .get,
            encoding: .json,
            headers: nil,
            onSuccess: { [weak self] (pokemon: Pokemon) in
                guard let self = self else { return }
                self.fetchPokemonDescription(speciesURL: pokemon.species.url) { description in
                    completion(pokemon, description)
                }
            },
            onFailure: { error in
                print("Error: \(error.message)")
                completion(nil, "Error: \(error.message)")
            }
        )
    }
    
    // Extrae el número de un Pokémon a partir de su URL
    func extractPokemonNumber(from urlString: String) -> Int? {
        let components = urlString.split(separator: "/")
        if let numberString = components.dropLast().last, let number = Int(numberString) {
            return number
        }
        return nil
    }
    
    // Obtiene una lista de nombres de Pokémon filtrados por tipo
    func fetchPokemonListByType(type: String, completion: @escaping ([String]?) -> Void) {
        let endpoint = "https://pokeapi.co/api/v2/type/\(type)"
        
        HTTPClient.request(
            endpoint: endpoint,
            method: .get,
            encoding: .json,
            headers: nil,
            onSuccess: { (response: PokemonTypeResponse) in
                let pokemonNames = response.pokemon.map { $0.pokemon.name }
                completion(pokemonNames)
            },
            onFailure: { error in
                print("Error al obtener Pokémon por tipo: \(error.message)")
                completion(nil)
            }
        )
    }
}

