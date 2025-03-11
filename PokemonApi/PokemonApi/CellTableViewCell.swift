//
//  CellTableViewCell.swift
//  PokemonApi
//
//  Created by bootcamp on 2025-03-11.
//

import UIKit

class CellTableViewCell: UITableViewCell {

    @IBOutlet weak var trailingImageView: UIImageView!
    @IBOutlet weak var tituloLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Código de inicialización adicional si es necesario
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
