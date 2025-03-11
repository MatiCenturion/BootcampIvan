//
//  PokemonDetailViewController.swift
//  PokemonApi
//
//  Created by bootcamp on 2025-03-11.
//

import UIKit
import Kingfisher

class PokemonDetailViewController: UIViewController {
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var pokemon: Pokemon?
    var pokemonDescription: String?
    
    // Llamamos updateUI en viewWillAppear para asegurarnos de que la vista ya esté cargada y los outlets conectados
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        guard let pokemon = pokemon else {
            print("Error: No se recibió objeto Pokemon")
            return
        }
        
        nameLabel.text = pokemon.name.capitalized
        typeLabel.text = "Tipo: \(pokemon.types.map { $0.type.name.capitalized }.joined(separator: ", "))"
        descriptionLabel.text = pokemonDescription ?? "Descripción no disponible"
        
        if let imageUrl = URL(string: pokemon.sprites.other.officialArtwork.frontDefault) {
            pokemonImageView.kf.setImage(with: imageUrl)
        } else {
            print("Error: URL de imagen no válida")
        }
    }
}

