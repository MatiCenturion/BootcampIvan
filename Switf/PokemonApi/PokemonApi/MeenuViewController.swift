//
//  ViewController.swift
//  PokemonApi
//
//  Created by bootcamp on 2025-03-10.
//


import UIKit
import Kingfisher


class MeenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pokemonSearchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchMethodTextField: UITextField!
    
    let searchMethodPicker = UIPickerView()
    // Estas propiedades siguen siendo usadas para la búsqueda por nombre/número
    var pokemonList: [String] = []
    var filteredPokemonList: [String] = []
    let searchMethods = ["Nombre", "Número"]
    let pokemonManager = PokemonManager()
    
    // Diccionario que mapea tipos en español a sus equivalentes en inglés
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
    
    // Nueva propiedad: secciones para agrupar los Pokémon por tipo
    var pokemonSections: [PokemonSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchMethodPicker()
        tableViewConfiguration()
        
        searchMethodTextField.delegate = self
        pokemonSearchBar.delegate = self
        
        // Configurar gesture para descartar el teclado fuera del Table View
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        // Funcionalidad existente: carga la lista completa para búsqueda por nombre/número
        pokemonManager.fetchPokemonList { [weak self] pokemonNames in
            guard let self = self, let names = pokemonNames else { return }
            DispatchQueue.main.async {
                self.pokemonList = names
                self.filteredPokemonList = names
                // (Esta lista se utiliza en los métodos searchByName/searchByNumber)
            }
        }
        
        // NUEVO: Configurar secciones agrupadas por tipo
        setupPokemonSections()
        
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "SectionHeaderView")
        
    }
    
    func setupPokemonSections() {
        pokemonSections = []
        // Para mantener un orden, se pueden ordenar los tipos (por ejemplo, alfabéticamente)
        let sortedTypes = typeMapping.sorted { $0.key < $1.key }
        for (spanishType, englishType) in sortedTypes {
            // Inicialmente, las secciones estarán contraídas (isExpanded = false)
            let  section = PokemonSection(typeName: spanishType.capitalized, englishType: englishType, pokemonNames: [], isExpanded: false)
            pokemonSections.append(section)
            // Llamada asíncrona para obtener la lista de Pokémon de cada tipo
            pokemonManager.fetchPokemonListByType(type: englishType) { [weak self] names in
                guard let self = self else { return }
                if let names = names {
                    if let index = self.pokemonSections.firstIndex(where: { $0.englishType == englishType }) {
                        self.pokemonSections[index].pokemonNames = names
                        DispatchQueue.main.async {
                            self.tableView.reloadSections(IndexSet(integer: index), with: .automatic)
                        }
                    }
                }
            }
        }
    }
    
    func tableViewConfiguration() {
        tableView.register(UINib(nibName: "CellTableViewCell", bundle: nil), forCellReuseIdentifier: "pokemonCell")
        // Registrar el header personalizado para las secciones
        tableView.register(UINib(nibName: "SectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SectionHeaderView")
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

// MARK: - UITableViewDelegate & DataSource para secciones
extension MeenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return pokemonSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Si la sección está expandida, se muestran las filas; si no, 0.
        return pokemonSections[section].isExpanded ? pokemonSections[section].pokemonNames.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell") as! CellTableViewCell
        let pokemonName = pokemonSections[indexPath.section].pokemonNames[indexPath.row]
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
    
    // Al seleccionar una celda se navega a la pantalla de detalle
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPokemon = pokemonSections[indexPath.section].pokemonNames[indexPath.row]
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
    
    // Configurar el header de cada sección usando el header personalizado
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView") as? SectionHeaderView else {
            return nil
        }
        let sectionData = pokemonSections[section]
        header.titleLabel.text = sectionData.typeName
        header.arrowImageView.transform = sectionData.isExpanded ? CGAffineTransform(rotationAngle: .pi / 2) : .identity
        header.tapCallback = { [weak self] in
            guard let self = self else { return }
            self.pokemonSections[section].isExpanded.toggle()
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
        return header
    }
    
    
    // Altura para el header de cada sección
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    // Mantener la altura de la celda existente
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}

// MARK: - UIPickerViewDelegate & DataSource, UITextFieldDelegate, UISearchBarDelegate
extension MeenuViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
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
    
    // Se puede implementar lógica de filtrado si se desea; por ahora se deja sin cambios para preservar las otras funcionalidades
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Opcional: implementar filtrado dentro de las secciones si se desea.
    }
}

// MARK: - UIGestureRecognizerDelegate
extension MeenuViewController: UIGestureRecognizerDelegate {
    // Se descarta el gesto si el toque proviene del Table View
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view, touchedView.isDescendant(of: tableView) {
            return false
        }
        return true
    }
}


