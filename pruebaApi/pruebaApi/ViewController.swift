//
//  ViewController.swift
//  pruebaApi
//
//  Created by bootcamp on 2025-03-07.
//

import UIKit
import Kingfisher
// import Stevia

class ViewController: UIViewController {
    
    @IBOutlet weak var pokemonTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    //    @IBOutlet weak var pokemonPicker: UIPickerView!
    
    var pokemonList: [String] = []
    
    let pokemonManager = PokemonManager()
    
    let pickerView = UIPickerView()
    let searchMethodTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Buscar por..."
        textField.layer.cornerRadius = 10.0
        textField.layer.borderWidth = 2.0
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.tintColor = .clear
        return textField
    }()
    
    var searchMethods = ["Nombre", "Número"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        
        
        pokemonManager.fetchPokemonList { [weak self] pokemonNames in
            guard let self = self, let names = pokemonNames else { return }
            DispatchQueue.main.async {
                self.pokemonList = names
            }
        }
        
        view.addSubview(searchMethodTextField)
        
        searchMethodTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchMethodTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Centrado horizontalmente
            searchMethodTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20), // Espaciado de 20 puntos desde la parte inferior
            searchMethodTextField.widthAnchor.constraint(equalToConstant: 200) // Ancho fijo de 200 puntos
        ])
        
        searchMethodTextField.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        searchMethodTextField.inputView = pickerView
        
        // ToolBar with Done button
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissPicker))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        searchMethodTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    func setupUI() {
        nameLabel.text = ""
        typeLabel.text = ""
        descriptionLabel.text = ""
        pokemonImageView.image = nil
    }
    
    @IBAction func searchPokemon(_ sender: UIButton) {
        guard !pokemonList.isEmpty else {
            showAlert(message: "La lista de Pokémon aún no ha cargado.")
            return
        }
        
        if let searchMethod = searchMethodTextField.text {
            if searchMethod == "Nombre" {
                searchByName()
            } else if searchMethod == "Número" {
                searchByNumber()
            }
        }
    }
    
    func searchByName() {
        guard let pokemonName = pokemonTextField.text else {
            showAlert(message: "Por favor ingresa un nombre de Pokémon")
            return
        }
        
        pokemonManager.fetchPokemonData(pokemonName: pokemonName) { [weak self] pokemon, description in
            guard let self = self, let pokemon = pokemon else {
                self?.showAlert(message: "No se encontró el Pokémon")
                return
            }
            
            DispatchQueue.main.async {
                self.updateUI(with: pokemon, description: description)
            }
        }
    }
    
    func searchByNumber() {
        guard let pokemonNumberString = pokemonTextField.text, let pokemonNumber = Int(pokemonNumberString) else {
            showAlert(message: "Por favor ingresa un número de Pokémon válido")
            return
        }
        // Aquí podrías descomentar y completar la llamada a fetchPokemonDataByNumber más adelante.
    }
    
    func updateUI(with pokemon: Pokemon, description: String?) {
        nameLabel.text = pokemon.name.capitalized
        typeLabel.text = "Tipo: \(pokemon.types.map { $0.type.name.capitalized }.joined(separator: ", "))"
        descriptionLabel.text = description ?? "Descripción no disponible"
        
        if let imageURL = URL(string: pokemon.sprites.front_default) {
            pokemonImageView.kf.setImage(with: imageURL)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return searchMethods.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return searchMethods[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchMethodTextField.text = searchMethods[row]
        
        if searchMethods[row] == "Nombre" {
            pokemonTextField.keyboardType = .default  // Teclado alfabético
        } else {
            pokemonTextField.keyboardType = .numberPad  // Teclado numérico
        }
        
        searchMethodTextField.resignFirstResponder()
        pokemonTextField.becomeFirstResponder() // Cambia automáticamente al campo de búsqueda
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchMethodTextField {
            return false // Evita que el usuario escriba manualmente en el campo del picker
        }
        return true
    }
}





