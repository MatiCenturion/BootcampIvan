//
//  ViewController.swift
//  PokemonApi
//
//  Created by bootcamp on 2025-03-10.
//
/*

import UIKit
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pokemonSearchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchMethodTextField: UITextField!
    
    let searchMethodPicker = UIPickerView()
    var pokemonList: [String] = []
    var filteredPokemonList: [String] = []
    let searchMethods = ["Nombre", "Número"]
    let pokemonManager = PokemonManager()
    
    let typeMapping: [String: String] = [
        "normal": "normal",
        "fuego": "fire",
        "agua": "water",
        "planta": "grass",
        "eléctrico": "electric",
        "hielo": "ice",
        "lucha": "fighting",
        "veneno": "poison",
        "tierra": "ground",
        "volador": "flying",
        "psíquico": "psychic",
        "bicho": "bug",
        "roca": "rock",
        "fantasma": "ghost",
        "dragón": "dragon",
        "siniestro": "dark",
        "acero": "steel",
        "hada": "fairy"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchMethodPicker()
        tableViewConfiguration()
        
        searchMethodTextField.delegate = self
        pokemonSearchBar.delegate = self
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tapGesture)
        
        pokemonManager.fetchPokemonList { [weak self] pokemonNames in
            guard let self = self, let names = pokemonNames else { return }
            DispatchQueue.main.async {
                self.pokemonList = names
                self.filteredPokemonList = names
                self.tableView.reloadData()
            }
        }
    }
    
    func tableViewConfiguration() {
        tableView.register(UINib(nibName: "CellTableViewCell", bundle: nil), forCellReuseIdentifier: "pokemonCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSearchMethodPicker() {
        searchMethodPicker.delegate = self
        searchMethodPicker.dataSource = self
        searchMethodTextField.inputView = searchMethodPicker
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(dismissPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        searchMethodTextField.inputAccessoryView = toolBar
        
        searchMethodTextField.text = searchMethods[0]
    }
    
    @objc private func dismissPicker() {
        view.endEditing(true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
        guard let pokemonName = pokemonSearchBar.text, !pokemonName.isEmpty else {
            showAlert(message: "Por favor ingresa un nombre de Pokémon")
            return
        }
        
        pokemonManager.fetchPokemonData(pokemonName: pokemonName) { [weak self] pokemon, description in
            guard let self = self, let pokemon = pokemon else {
                self?.showAlert(message: "No se encontró el Pokémon")
                return
            }
            DispatchQueue.main.async {
                guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as? PokemonDetailViewController else {
                    print("No se encontró el view controller con el identificador 'PokemonDetailViewController'")
                    return
                }
                detailVC.pokemon = pokemon
                detailVC.pokemonDescription = description
                
                // Si existe navigationController, se realiza push, de lo contrario se presenta modally.
                if let nav = self.navigationController {
                    nav.pushViewController(detailVC, animated: true)
                } else {
                    self.present(detailVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func searchByNumber() {
        guard let pokemonNumberString = pokemonSearchBar.text, let pokemonNumber = Int(pokemonNumberString) else {
            showAlert(message: "Por favor ingresa un número de Pokémon válido")
            return
        }
        
        pokemonManager.fetchPokemonDataByNumber(pokemonNumber: pokemonNumber) { [weak self] pokemon, description in
            guard let self = self, let pokemon = pokemon else {
                self?.showAlert(message: "No se encontró el Pokémon")
                return
            }
            DispatchQueue.main.async {
                guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as? PokemonDetailViewController else {
                    print("No se encontró el view controller con el identificador 'PokemonDetailViewController'")
                    return
                }
                detailVC.pokemon = pokemon
                detailVC.pokemonDescription = description
                
                if let nav = self.navigationController {
                    nav.pushViewController(detailVC, animated: true)
                } else {
                    self.present(detailVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell") as! CellTableViewCell
        let pokemonName = filteredPokemonList[indexPath.row]
        cell.tituloLabel.text = pokemonName
        cell.trailingImageView.image = nil
        
        pokemonManager.fetchPokemonData(pokemonName: pokemonName) { [weak tableView] (pokemon, description) in
            guard let pokemon = pokemon, let imageUrl = URL(string: pokemon.sprites.other.officialArtwork.frontDefault) else { return }
            DispatchQueue.main.async {
                if let currentCell = tableView?.cellForRow(at: indexPath) as? CellTableViewCell {
                    currentCell.trailingImageView.kf.setImage(with: imageUrl)
                }
            }
        }
        return cell
    }
    func showDetail(pokemon) {
        
//        show(<#T##vc: UIViewController##UIViewController#>, sender: <#T##Any?#>)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedPokemon = filteredPokemonList[indexPath.row]
//        pokemonSearchBar.text = selectedPokemon
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPokemon = filteredPokemonList[indexPath.row]
        pokemonSearchBar.text = selectedPokemon
        // Actualiza la lista filtrada para mostrar solo el Pokemon seleccionado
        filteredPokemonList = [selectedPokemon]
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        showDetail(selectedPokemon)
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    // PickerView Methods
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
        pokemonSearchBar.text = ""
        if let searchTextField = pokemonSearchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.keyboardType = searchMethods[row] == "Número" ? .numberPad : .default
            searchTextField.reloadInputViews()
        }
    }
    
    // SearchBar Method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let lowercasedSearch = searchText.lowercased()
        if let englishType = typeMapping[lowercasedSearch] {
            pokemonManager.fetchPokemonListByType(type: englishType) { [weak self] typePokemonNames in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.filteredPokemonList = typePokemonNames ?? []
                    self.tableView.reloadData()
                }
            }
        } else {
            if searchText.isEmpty {
                filteredPokemonList = pokemonList
            } else {
                filteredPokemonList = pokemonList.filter { $0.lowercased().contains(lowercasedSearch) }
            }
            tableView.reloadData()
        }
    }
}
*/

import UIKit
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pokemonSearchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchMethodTextField: UITextField!
    
    let searchMethodPicker = UIPickerView()
    var pokemonList: [String] = []
    var filteredPokemonList: [String] = []
    let searchMethods = ["Nombre", "Número"]
    let pokemonManager = PokemonManager()
    
    let typeMapping: [String: String] = [
        "normal": "normal",
        "fuego": "fire",
        "agua": "water",
        "planta": "grass",
        "eléctrico": "electric",
        "hielo": "ice",
        "lucha": "fighting",
        "veneno": "poison",
        "tierra": "ground",
        "volador": "flying",
        "psíquico": "psychic",
        "bicho": "bug",
        "roca": "rock",
        "fantasma": "ghost",
        "dragón": "dragon",
        "siniestro": "dark",
        "acero": "steel",
        "hada": "fairy"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchMethodPicker()
        tableViewConfiguration()
        
        searchMethodTextField.delegate = self
        pokemonSearchBar.delegate = self
        
        // Se configura el tap gesture para descartar el teclado solo fuera del Table View
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        pokemonManager.fetchPokemonList { [weak self] pokemonNames in
            guard let self = self, let names = pokemonNames else { return }
            DispatchQueue.main.async {
                self.pokemonList = names
                self.filteredPokemonList = names
                self.tableView.reloadData()
            }
        }
    }
    
    func tableViewConfiguration() {
        tableView.register(UINib(nibName: "CellTableViewCell", bundle: nil), forCellReuseIdentifier: "pokemonCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSearchMethodPicker() {
        searchMethodPicker.delegate = self
        searchMethodPicker.dataSource = self
        searchMethodTextField.inputView = searchMethodPicker
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(dismissPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        searchMethodTextField.inputAccessoryView = toolBar
        
        searchMethodTextField.text = searchMethods[0]
    }
    
    @objc private func dismissPicker() {
        view.endEditing(true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
        guard let pokemonName = pokemonSearchBar.text, !pokemonName.isEmpty else {
            showAlert(message: "Por favor ingresa un nombre de Pokémon")
            return
        }
        
        pokemonManager.fetchPokemonData(pokemonName: pokemonName) { [weak self] pokemon, description in
            guard let self = self, let pokemon = pokemon else {
                self?.showAlert(message: "No se encontró el Pokémon")
                return
            }
            DispatchQueue.main.async {
                guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as? PokemonDetailViewController else {
                    print("No se encontró el view controller con el identificador 'PokemonDetailViewController'")
                    return
                }
                detailVC.pokemon = pokemon
                detailVC.pokemonDescription = description
                if let nav = self.navigationController {
                    nav.pushViewController(detailVC, animated: true)
                } else {
                    self.present(detailVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func searchByNumber() {
        guard let pokemonNumberString = pokemonSearchBar.text, let pokemonNumber = Int(pokemonNumberString) else {
            showAlert(message: "Por favor ingresa un número de Pokémon válido")
            return
        }
        
        pokemonManager.fetchPokemonDataByNumber(pokemonNumber: pokemonNumber) { [weak self] pokemon, description in
            guard let self = self, let pokemon = pokemon else {
                self?.showAlert(message: "No se encontró el Pokémon")
                return
            }
            DispatchQueue.main.async {
                guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as? PokemonDetailViewController else {
                    print("No se encontró el view controller con el identificador 'PokemonDetailViewController'")
                    return
                }
                detailVC.pokemon = pokemon
                detailVC.pokemonDescription = description
                if let nav = self.navigationController {
                    nav.pushViewController(detailVC, animated: true)
                } else {
                    self.present(detailVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate & DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell") as! CellTableViewCell
        let pokemonName = filteredPokemonList[indexPath.row]
        cell.tituloLabel.text = pokemonName
        cell.trailingImageView.image = nil
        
        pokemonManager.fetchPokemonData(pokemonName: pokemonName) { [weak tableView] (pokemon, description) in
            guard let pokemon = pokemon, let imageUrl = URL(string: pokemon.sprites.other.officialArtwork.frontDefault) else { return }
            DispatchQueue.main.async {
                if let currentCell = tableView?.cellForRow(at: indexPath) as? CellTableViewCell {
                    currentCell.trailingImageView.kf.setImage(with: imageUrl)
                }
            }
        }
        return cell
    }
    
    // Al seleccionar una celda se obtiene el detalle del Pokémon y se navega directamente a la pantalla de detalle
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPokemon = filteredPokemonList[indexPath.row]
        pokemonManager.fetchPokemonData(pokemonName: selectedPokemon) { [weak self] pokemon, description in
            guard let self = self, let pokemon = pokemon else {
                self?.showAlert(message: "No se encontró el Pokémon")
                return
            }
            DispatchQueue.main.async {
                guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as? PokemonDetailViewController else {
                    print("No se encontró el view controller con el identificador 'PokemonDetailViewController'")
                    return
                }
                detailVC.pokemon = pokemon
                detailVC.pokemonDescription = description
                if let nav = self.navigationController {
                    nav.pushViewController(detailVC, animated: true)
                } else {
                    self.present(detailVC, animated: true, completion: nil)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}

// MARK: - UIPickerViewDelegate & DataSource
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
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
        pokemonSearchBar.text = ""
        if let searchTextField = pokemonSearchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.keyboardType = searchMethods[row] == "Número" ? .numberPad : .default
            searchTextField.reloadInputViews()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let lowercasedSearch = searchText.lowercased()
        if let englishType = typeMapping[lowercasedSearch] {
            pokemonManager.fetchPokemonListByType(type: englishType) { [weak self] typePokemonNames in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.filteredPokemonList = typePokemonNames ?? []
                    self.tableView.reloadData()
                }
            }
        } else {
            if searchText.isEmpty {
                filteredPokemonList = pokemonList
            } else {
                filteredPokemonList = pokemonList.filter { $0.lowercased().contains(lowercasedSearch) }
            }
            tableView.reloadData()
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ViewController: UIGestureRecognizerDelegate {
    // Se descarta el gesto si el toque proviene del Table View
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view, touchedView.isDescendant(of: tableView) {
            return false
        }
        return true
    }
}

