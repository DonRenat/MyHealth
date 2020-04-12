//
//  RegistrationViewController.swift
//  MyHealth
//
//  Created by Renat Gasanov on 13.04.2020.
//  Copyright © 2020 Renat Gasanov. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var text1: SkyFloatingLabelTextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.text1.delegate = self
        
        doneButton.layer.cornerRadius = 15
        doneButton.layer.cornerCurve = .continuous
    }
    
    @IBAction func doneButtonClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
