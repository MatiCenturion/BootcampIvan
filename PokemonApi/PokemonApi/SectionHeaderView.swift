//
//  SectionHeaderView.swift
//  PokemonApi
//
//  Created by bootcamp on 2025-03-12.
//
import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Componentes
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        // Utilizamos una imagen de sistema; puedes cambiarla por otra
        imageView.image = UIImage(systemName: "chevron.right")
        return imageView
    }()
    
    // Closure para manejar el toque en el header
    var tapCallback: (() -> Void)?
    
    // MARK: - Inicializadores
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        addTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        addTapGesture()
    }
    
    // MARK: - Configuración de la vista
    private func setupViews() {
        // Agregar componentes al contentView del header
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
        
        // Configurar Auto Layout
        NSLayoutConstraint.activate([
            // titleLabel: margen izquierdo y centrado vertical
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // arrowImageView: margen derecho y centrado vertical
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func headerTapped() {
        tapCallback?()
    }
}
