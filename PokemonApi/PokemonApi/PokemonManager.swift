//
//  PokemonManager.swift
//  PokemonApi
//
//  Created by bootcamp on 2025-03-10.
//
import Foundation

class PokemonManager {
    
    // Obtiene datos de un Pokémon por nombre
    func fetchPokemonData(pokemonName: String, completion: @escaping (Pokemon?, String?) -> Void) {
        let endpoint = "https://pokeapi.co/api/v2/pokemon/\(pokemonName.lowercased())"
        HTTPClient.request(
            endpoint: endpoint,
            method: .get,
            encoding: .json,
            headers: nil,
            onSuccess: { (pokemon: Pokemon) in
                self.fetchPokemonDescription(speciesURL: pokemon.species.url, completion: { description in
                    completion(pokemon, description)
                })
            },
            onFailure: { error in
                print("Error: \(error.message)")
                completion(nil, nil)
            }
        )
    }
    
    // Obtiene la descripción del Pokémon desde la URL de especie
    func fetchPokemonDescription(speciesURL: String, completion: @escaping (String?) -> Void) {
        HTTPClient.request(
            endpoint: speciesURL,
            method: .get,
            encoding: .json,
            headers: nil,
            onSuccess: { (speciesData: PokemonSpecies) in
                if let descriptionEntry = speciesData.flavor_text_entries.first(where: { $0.language.name == "es" }) {
                    completion(descriptionEntry.flavor_text)
                } else {
                    completion(speciesData.flavor_text_entries.first?.flavor_text)
                }
            },
            onFailure: { error in
                print("Error: \(error.message)")
                completion(nil)
            }
        )
    }
    
    // Obtiene la lista de 50 Pokémon
    func fetchPokemonList(completion: @escaping ([String]?) -> Void) {
        let endpoint = "https://pokeapi.co/api/v2/pokemon?limit=50"
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
    
    // Obtiene datos de un Pokémon por número (ID)
    func fetchPokemonDataByNumber(pokemonNumber: Int, completion: @escaping (Pokemon?, String?) -> Void) {
        let endpoint = "https://pokeapi.co/api/v2/pokemon/\(pokemonNumber)"
        HTTPClient.request(
            endpoint: endpoint,
            method: .get,
            encoding: .json,
            headers: nil,
            onSuccess: { (pokemon: Pokemon) in
                self.fetchPokemonDescription(speciesURL: pokemon.species.url, completion: { description in
                    completion(pokemon, description)
                })
            },
            onFailure: { error in
                print("Error: \(error.message)")
                completion(nil, "Error: \(error.message)")
            }
        )
    }
    
    // Extrae el número del Pokémon a partir de su URL
    func extractPokemonNumber(from urlString: String) -> Int? {
        let components = urlString.split(separator: "/")
        if let numberString = components.dropLast().last,
           let number = Int(numberString) {
            return number
        }
        return nil
    }
}

