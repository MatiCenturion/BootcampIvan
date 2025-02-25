//
//  ViewController.swift
//  Login
//
//  Created by bootcamp on 2025-02-25.
//

import UIKit

class EmailViewController: UIViewController {
    
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var enviarButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelEmail.text = "e enviaremos un correo de confirmacion"
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}

