//
//  NewUserViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//

import UIKit

class NewUserViewController: UIViewController {
    @IBOutlet weak var aceptarNewUserTextField: UIButton!
    @IBOutlet weak var cancelarNewUserTextField: UIButton!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newUserTextField: UITextField!
    
    @IBOutlet weak var tituloLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tituloLabel.text = "Ingrese Nuevo Usuario"
    }
    


}
