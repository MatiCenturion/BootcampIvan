//
//  ViewController.swift
//  PokemonApi
//
//  Created by bootcamp on 2025-03-10.
//


import UIKit // Importa UIKit para la interfaz de usuario
import Kingfisher // Importa Kingfisher para la carga de imágenes desde URL

// Clase principal que maneja la vista de búsqueda y despliegue de datos de Pokémon
class ViewController: UIViewController {
    @IBOutlet weak var pokemonSearchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var searchMethodTextField: UITextField!
    @IBOutlet weak var selectPokemonPickerView: UIPickerView!
    
    let searchMethodPicker = UIPickerView() // Picker para seleccionar el método de búsqueda (por nombre o número)
    var pokemonList: [String] = [] // Lista completa de nombres de Pokémon obtenidos de la API
    var filteredPokemonList: [String] = [] // Lista de Pokémon filtrados según lo ingresado en la búsqueda
    let searchMethods = ["Nombre", "Número"] // Métodos de búsqueda disponibles
    let pokemonManager = PokemonManager() // Instancia que gestiona la obtención de datos de Pokémon
    
    // Diccionario para mapear nombres de tipos en español a los correspondientes en inglés de la API
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
    
    // Método que se ejecuta al cargar la vista
    override func viewDidLoad() {
        super.viewDidLoad() // Llama al método de la superclase
        setupUI() // Configura los elementos visuales iniciales
        setupSearchMethodPicker() // Configura el picker para seleccionar el método de búsqueda
        
        selectPokemonPickerView.delegate = self // Asigna self como delegado del picker de selección de Pokémon
        selectPokemonPickerView.dataSource = self // Asigna self como fuente de datos del picker de selección
        
        searchMethodTextField.delegate = self // Asigna self como delegado del campo de texto de método de búsqueda
        pokemonSearchBar.delegate = self // Asigna self como delegado de la barra de búsqueda
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)) // Crea un gesto para ocultar el teclado al tocar fuera
        view.addGestureRecognizer(tapGesture) // Agrega el gesto a la vista principal
        
        // Carga la lista completa de Pokémon desde la API
        pokemonManager.fetchPokemonList { [weak self] pokemonNames in
            guard let self = self, let names = pokemonNames else { return } // Verifica que self y los nombres no sean nulos
            DispatchQueue.main.async { // Se asegura de ejecutar en el hilo principal
                self.pokemonList = names // Asigna la lista completa obtenida
                self.filteredPokemonList = names // Inicialmente, la lista filtrada es la lista completa
                self.selectPokemonPickerView.reloadAllComponents() // Recarga el picker para mostrar los datos
            }
        }
    }
    
    // Configura el picker para seleccionar el método de búsqueda
    private func setupSearchMethodPicker() {
        searchMethodPicker.delegate = self // Asigna self como delegado del picker de método
        searchMethodPicker.dataSource = self // Asigna self como fuente de datos del picker de método
        searchMethodTextField.inputView = searchMethodPicker // Asigna el picker como entrada del campo de texto
        
        let toolBar = UIToolbar() // Crea una barra de herramientas para el picker
        toolBar.sizeToFit() // Ajusta el tamaño de la barra al contenido
        let doneButton = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(dismissPicker)) // Crea un botón "Listo" para cerrar el picker
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // Crea un espacio flexible en la barra
        toolBar.setItems([flexibleSpace, doneButton], animated: true) // Agrega el espacio y el botón a la barra
        searchMethodTextField.inputAccessoryView = toolBar // Asigna la barra de herramientas como accesorio al campo de texto
        
        searchMethodTextField.text = searchMethods[0] // Establece el método de búsqueda predeterminado ("Nombre")
    }
    
    // Método que cierra el picker y el teclado
    @objc private func dismissPicker() {
        view.endEditing(true) // Oculta el teclado y cualquier vista de entrada activa
    }
    
    // Método para ocultar el teclado al tocar fuera de él
    @objc private func dismissKeyboard() {
        view.endEditing(true) // Oculta el teclado
    }
    
    // Configura la interfaz inicial de la vista
    func setupUI() {
        nameLabel.text = ""
        typeLabel.text = ""
        descriptionLabel.text = ""
        pokemonImageView.image = nil
    }
    
    // Acción al presionar el botón de búsqueda
    @IBAction func searchPokemon(_ sender: UIButton) {
        guard !pokemonList.isEmpty else {
            showAlert(message: "La lista de Pokémon aún no ha cargado.")
            return
        }
        
        if let searchMethod = searchMethodTextField.text { // Obtiene el método de búsqueda seleccionado
            if searchMethod == "Nombre" { // Si el método es buscar por nombre
                searchByName() // Llama a la función para buscar por nombre
            } else if searchMethod == "Número" { // Si el método es buscar por número
                searchByNumber() // Llama a la función para buscar por número
            }
        }
    }
    
    // Función para buscar un Pokémon por su nombre
    func searchByName() {
        guard let pokemonName = pokemonSearchBar.text, !pokemonName.isEmpty else { // Verifica que se haya ingresado un nombre
            showAlert(message: "Por favor ingresa un nombre de Pokémon") // Muestra alerta si no se ingresó nombre
            return // Sale de la función
        }
        
        // Llama a la función del gestor para obtener datos del Pokémon por nombre
        pokemonManager.fetchPokemonData(pokemonName: pokemonName) { [weak self] pokemon, description in
            guard let self = self, let pokemon = pokemon else { // Verifica que se hayan obtenido datos
                self?.showAlert(message: "No se encontró el Pokémon") // Muestra alerta si no se encontró el Pokémon
                return // Sale de la función
            }
            DispatchQueue.main.async { // Actualiza la UI en el hilo principal
                self.updateUI(with: pokemon, description: description) // Actualiza la interfaz con los datos obtenidos
            }
        }
    }
    
    // Función para buscar un Pokémon por su número (ID)
    func searchByNumber() {
        guard let pokemonNumberString = pokemonSearchBar.text, let pokemonNumber = Int(pokemonNumberString) else { // Verifica que se haya ingresado un número válido
            showAlert(message: "Por favor ingresa un número de Pokémon válido") // Muestra alerta si el número es inválido
            return // Sale de la función
        }
        // Llama a la función del gestor para obtener datos del Pokémon por número
        pokemonManager.fetchPokemonDataByNumber(pokemonNumber: pokemonNumber) { [weak self] pokemon, description in
            guard let self = self, let pokemon = pokemon else { // Verifica que se hayan obtenido datos
                self?.showAlert(message: "No se encontró el Pokémon") // Muestra alerta si no se encontró el Pokémon
                return // Sale de la función
            }
            DispatchQueue.main.async { // Actualiza la UI en el hilo principal
                self.updateUI(with: pokemon, description: description) // Actualiza la interfaz con los datos obtenidos
            }
        }
    }
    
    // Función para actualizar la interfaz de usuario con la información del Pokémon
    func updateUI(with pokemon: Pokemon, description: String?) {
        nameLabel.text = pokemon.name.capitalized // Muestra el nombre del Pokémon con la primera letra en mayúscula
        // Muestra los tipos del Pokémon, cada uno capitalizado y separados por comas
        typeLabel.text = "Tipo: \(pokemon.types.map { $0.type.name.capitalized }.joined(separator: ", "))"
        descriptionLabel.text = description ?? "Descripción no disponible" // Muestra la descripción o un mensaje por defecto si no hay
        if let imageUrl = URL(string: pokemon.sprites.other.officialArtwork.frontDefault) { // Verifica que la URL de la imagen sea válida
            pokemonImageView.kf.setImage(with: imageUrl) // Carga la imagen del Pokémon usando Kingfisher
        }
    }
    
    // Función para mostrar una alerta con un mensaje de error
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert) // Crea una alerta con el mensaje
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil)) // Agrega un botón "OK" a la alerta
        present(alert, animated: true, completion: nil) // Presenta la alerta en la vista
    }
}

// Extensiones para implementar los delegados de UIPickerView, UITextField y UISearchBar
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
    
    // Devuelve el número de componentes (columnas) del picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Se utiliza una sola columna en el picker
    }
    
    // Devuelve el número de filas para un componente del picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == searchMethodPicker { // Si el picker es el de métodos de búsqueda
            return searchMethods.count // Retorna la cantidad de métodos disponibles
        } else if pickerView == selectPokemonPickerView { // Si el picker es el de selección de Pokémon
            return filteredPokemonList.count // Retorna la cantidad de Pokémon filtrados
        }
        return 0 // Para cualquier otro picker, retorna 0
    }
    
    // Devuelve el título para una fila en el picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == searchMethodPicker { // Si el picker es el de métodos de búsqueda
            return searchMethods[row] // Retorna el método correspondiente
        } else if pickerView == selectPokemonPickerView { // Si el picker es el de selección de Pokémon
            return filteredPokemonList[row] // Retorna el nombre del Pokémon filtrado
        }
        return nil // En otros casos, retorna nil
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == searchMethodPicker { // Si se selecciona un método de búsqueda en el picker de métodos
            searchMethodTextField.text = searchMethods[row] // Actualiza el campo de texto con el método elegido
            pokemonSearchBar.text = "" // Limpia la barra de búsqueda
            
            // Obtiene el UITextField interno del UISearchBar para modificar su teclado
            if let searchTextField = pokemonSearchBar.value(forKey: "searchField") as? UITextField {
                // Si se selecciona "Número", establece el teclado numérico; de lo contrario, usa el teclado por defecto
                searchTextField.keyboardType = searchMethods[row] == "Número" ? .numberPad : .default
                searchTextField.reloadInputViews() // Recarga el teclado para que el cambio surta efecto
            }
        } else if pickerView == selectPokemonPickerView { // Si se selecciona un Pokémon de la lista filtrada
            pokemonSearchBar.text = filteredPokemonList[row] // Actualiza la barra de búsqueda con el nombre seleccionado
        }
    }
    
    
    // Se llama cada vez que cambia el texto en la barra de búsqueda
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let lowercasedSearch = searchText.lowercased() // Convierte el texto ingresado a minúsculas para comparación
        
        // Verifica si el texto coincide exactamente con alguno de los tipos definidos en el diccionario
        if let englishType = typeMapping[lowercasedSearch] { // Si existe una clave que coincide (por ejemplo, "fuego")
            // Llama al método para obtener la lista de Pokémon filtrados por el tipo correspondiente
            pokemonManager.fetchPokemonListByType(type: englishType) { [weak self] typePokemonNames in
                guard let self = self else { return } // Asegura que self n sea nil
                DispatchQueue.main.async { // Actualiza la UI en el hilo principal
                    if let typePokemonNames = typePokemonNames { // Si se obtuvieron nombres para el tipo
                        self.filteredPokemonList = typePokemonNames // Actualiza la lista filtrada con estos nombres
                    } else { // Si no se obtuvieron nombres
                        self.filteredPokemonList = [] // Establece la lista filtrada como vacía
                    }
                    self.selectPokemonPickerView.reloadAllComponents() // Recarga el picker para mostrar los cambios
                }
            }
        } else { // Si el texto no coincide con ningún tipo específico
            if searchText.isEmpty { // Si no se ha ingresado texto
                filteredPokemonList = pokemonList // Restaura la lista completa de Pokémon
            } else { // Si se ingresó texto y no es un tipo definido
                // Filtra la lista de Pokémon buscando aquellos que contengan el texto ingresado
                filteredPokemonList = pokemonList.filter { $0.lowercased().contains(lowercasedSearch) }
            }
            selectPokemonPickerView.reloadAllComponents() // Recarga el picker para mostrar los cambios
        }
    }
}



