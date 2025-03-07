//
//  PokemonManager.swift
//  pruebaApi
//
//  Created by bootcamp on 2025-03-07.
//

import Foundation
import Alamofire

class PokemonManager {
    
    // Función para obtener datos de un Pokémon por nombre
    func fetchPokemonData(pokemonName: String, completion: @escaping (Pokemon?, String?) -> Void) {
        let url = "https://pokeapi.co/api/v2/pokemon/\(pokemonName.lowercased())"
        
        // Hacemos la petición con Alamofire
        AF.request(url).responseDecodable(of: Pokemon.self) { response in
            switch response.result {
            case .success(let pokemon):
                // Obtener la descripción después de obtener el Pokémon
                self.fetchPokemonDescription(speciesURL: pokemon.species.url) { description in
                    completion(pokemon, description)
                }
            case .failure(let error):
                print("Error al obtener datos: \(error)")
                completion(nil, nil)
            }
        }
    }
    
    
    
    
    // Función para obtener la descripción del Pokémon
    func fetchPokemonDescription(speciesURL: String, completion: @escaping (String?) -> Void) {
        AF.request(speciesURL).responseDecodable(of: PokemonSpecies.self) { response in
            switch response.result {
            case .success(let speciesData):
                // Buscar la descripción en español o tomar la primera disponible
                if let descriptionEntry = speciesData.flavor_text_entries.first(where: { $0.language.name == "es" }) {
                    completion(descriptionEntry.flavor_text)
                } else {
                    completion(speciesData.flavor_text_entries.first?.flavor_text)
                }
            case .failure(let error):
                print("Error al obtener la descripción: \(error)")
                completion(nil)
            }
        }
    }
    
    
    func fetchPokemonList(completion: @escaping ([String]?) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=50" // Traerá 50 Pokémon
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        AF.request(url).responseDecodable(of: PokemonListResponse.self) { response in
            switch response.result {
            case .success(let data):
                let pokemonNames = data.results.map { $0.name }
                completion(pokemonNames)
            case .failure:
                completion(nil)
            }
        }
    }
    
    
    
    func fetchPokemonDataByNumber(pokemonNumber: Int, completion: @escaping (Pokemon?, String?) -> Void) {
        // Formamos la URL usando el número del Pokémon
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemonNumber)"
        
        // Convertimos el String a una URL
        guard let url = URL(string: urlString) else {
            completion(nil, "URL inválida")
            return
        }
        
        // Hacemos la solicitud HTTP para obtener los datos del Pokémon
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, "Error al obtener datos: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion(nil, "No se recibió datos")
                return
            }
            
            // Aquí parseamos los datos en formato JSON
            do {
                let decoder = JSONDecoder()
                let pokemon = try decoder.decode(Pokemon.self, from: data)
                
                // Supongamos que la descripción es un campo opcional en la respuesta
                // En PokéAPI la descripción la encontramos en una llamada a otro endpoint:
                let descriptionURL = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(pokemonNumber)")!
                let descriptionTask = URLSession.shared.dataTask(with: descriptionURL) { (descData, _, _) in
                    if let descData = descData {
                        do {
                            let species = try JSONDecoder().decode(PokemonSpecies.self, from: descData)
                            let description = species.flavor_text_entries.first { $0.language.name == "en" }?.flavor_text
                            completion(pokemon, description)
                        } catch {
                            completion(nil, "No se pudo obtener la descripción")
                        }
                    } else {
                        completion(nil, "No se encontró la descripción")
                    }
                }
                descriptionTask.resume()
                
            } catch {
                completion(nil, "Error al parsear datos")
            }
        }
        
        task.resume()
    }
    
    func extractPokemonNumber(from urlString: String) -> Int? {
        let components = urlString.split(separator: "/")
        // El número del Pokémon está en la penúltima parte de la URL
        if let numberString = components.dropLast().last,
           let number = Int(numberString) {
            return number
        }
        return nil
    }
    
    
}

