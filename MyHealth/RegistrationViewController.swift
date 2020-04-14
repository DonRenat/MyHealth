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

    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var famTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var snTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var doneButton: UIButton!
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(textFieldShouldReturn(_:)))
    let accessoryToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        famTextField.delegate = self
        
        doneButton.layer.cornerRadius = 15
        doneButton.layer.cornerCurve = .continuous
        
        done.tintColor = .white
        let items = [flexSpace, done]
        accessoryToolBar.items = items
        accessoryToolBar.sizeToFit()
        self.snTextField.inputAccessoryView = self.accessoryToolBar
    }
    
    @IBAction func doneButtonClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
