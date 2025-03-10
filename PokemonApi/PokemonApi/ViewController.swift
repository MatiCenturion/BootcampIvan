//
//  ViewController.swift
//  PokemonApi
//
//  Created by bootcamp on 2025-03-10.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var pokemonTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var searchMethodTextField: UITextField!
    @IBOutlet weak var selectPokemonPickerView: UIPickerView!  // Picker conectado desde el Storyboard
    
    // Picker para elegir el método de búsqueda ("Nombre" o "Número")
    let searchMethodPicker = UIPickerView()
    
    var pokemonList: [String] = []
    var filteredPokemonList: [String] = []
    
    let searchMethods = ["Nombre", "Número"]
    
    let pokemonManager = PokemonManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Configurar el picker para seleccionar "Nombre" o "Número"
        setupSearchMethodPicker()
        
        // Configurar el picker de Pokémon (usando el IBOutlet)
        selectPokemonPickerView.delegate = self
        selectPokemonPickerView.dataSource = self
        
        // Delegados para los textFields
        searchMethodTextField.delegate = self
        pokemonTextField.delegate = self
        
        // Agregar gesto para ocultar el teclado al tocar fuera
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Cargar la lista de Pokémon
        pokemonManager.fetchPokemonList { [weak self] pokemonNames in
            guard let self = self, let names = pokemonNames else { return }
            DispatchQueue.main.async {
                self.pokemonList = names
                self.filteredPokemonList = names
                self.selectPokemonPickerView.reloadAllComponents()
            }
        }
    }
    
    // Configuración del picker para seleccionar "Nombre" o "Número"
    private func setupSearchMethodPicker() {
        searchMethodPicker.delegate = self
        searchMethodPicker.dataSource = self
        searchMethodTextField.inputView = searchMethodPicker
        
        // Toolbar con botón "Listo" para el picker de método de búsqueda
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(dismissPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        searchMethodTextField.inputAccessoryView = toolBar
        
        // Valor por defecto
        searchMethodTextField.text = searchMethods[0]
    }
    
    @objc private func dismissPicker() {
        view.endEditing(true)
    }
    
    @objc private func dismissKeyboard() {
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
    
    // Búsqueda por nombre usando HTTPClient
    func searchByName() {
        guard let pokemonName = pokemonTextField.text, !pokemonName.isEmpty else {
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
    
    // Búsqueda por número (ID)
    func searchByNumber() {
        guard let pokemonNumberString = pokemonTextField.text, let pokemonNumber = Int(pokemonNumberString) else {
            showAlert(message: "Por favor ingresa un número de Pokémon válido")
            return
        }
        pokemonManager.fetchPokemonDataByNumber(pokemonNumber: pokemonNumber) { [weak self] pokemon, description in
            guard let self = self, let pokemon = pokemon else {
                self?.showAlert(message: "No se encontró el Pokémon")
                return
            }
            DispatchQueue.main.async {
                self.updateUI(with: pokemon, description: description)
            }
        }
    }
    
    // Actualiza la UI con los datos del Pokémon
    func updateUI(with pokemon: Pokemon, description: String?) {
        nameLabel.text = pokemon.name.capitalized
        typeLabel.text = "Tipo: \(pokemon.types.map { $0.type.name.capitalized }.joined(separator: ", "))"
        descriptionLabel.text = description ?? "Descripción no disponible"
        if let imageUrl = URL(string: pokemon.sprites.other.officialArtwork.frontDefault) {
            pokemonImageView.kf.setImage(with: imageUrl)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIPickerView & UITextField Delegates y DataSource
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // Un solo componente para ambos pickers
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Número de filas según el picker utilizado
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == searchMethodPicker {
            return searchMethods.count
        } else if pickerView == selectPokemonPickerView {
            return filteredPokemonList.count
        }
        return 0
    }
    
    // Título de cada fila según el picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == searchMethodPicker {
            return searchMethods[row]
        } else if pickerView == selectPokemonPickerView {
            return filteredPokemonList[row]
        }
        return nil
    }
    
    // Al seleccionar una fila en los pickers
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == searchMethodPicker {
            searchMethodTextField.text = searchMethods[row]
            // Configurar el tipo de teclado del pokemonTextField según la opción
            pokemonTextField.keyboardType = searchMethods[row] == "Nombre" ? .default : .numberPad
            searchMethodTextField.resignFirstResponder()
            // Al cambiar el método, se limpia el campo para evitar conflictos
            pokemonTextField.text = ""
        } else if pickerView == selectPokemonPickerView {
            // Al seleccionar un Pokémon del picker, se actualiza el textField
            pokemonTextField.text = filteredPokemonList[row]
        }
    }
    
    // Mientras se escribe en el pokemonTextField se filtra la lista del picker
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchMethodTextField {
            return false  // Evitar edición manual del campo de método de búsqueda
        }
        
        if textField == pokemonTextField {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            if newText.isEmpty {
                filteredPokemonList = pokemonList
            } else {
                filteredPokemonList = pokemonList.filter { $0.lowercased().contains(newText.lowercased()) }
            }
            selectPokemonPickerView.reloadAllComponents()
        }
        return true
    }
}
