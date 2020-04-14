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
    @IBOutlet weak var birthdayTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var weightTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var snTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var doneButton: UIButton!
    
    private var datePicker: UIDatePicker?
    var heighPicker: TYHeightPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        famTextField.delegate = self
        
        doneButton.layer.cornerRadius = 15
        doneButton.layer.cornerCurve = .continuous
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(RegistrationViewController.dateChanged(datePicker:)), for: .valueChanged)
        birthdayTextField.inputView = datePicker
        
        datePicker?.minimumDate = Calendar.current.date(byAdding: .year, value: -110, to: Date())
        datePicker?.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        datePicker?.locale = Locale(identifier: "ru_RU")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        setupTYHeightPicker()
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        heighPicker.addGestureRecognizer(tapGesture2)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        birthdayTextField.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    func saveData(){
        UserDefaults.standard.set(nameTextField.text, forKey: "NameKey")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func doneButtonClick(_ sender: UIButton) {
        if (!nameTextField.text!.isEmpty && !famTextField.text!.isEmpty && !birthdayTextField.text!.isEmpty && !weightTextField.text!.isEmpty && !snTextField.text!.isEmpty){
            saveData()
            
            if let parent = self.presentingViewController {
                parent.viewWillAppear(true)
            }
            
            self.dismiss(animated: true, completion: nil)
        } else {
            //handle empty text fields
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setupTYHeightPicker() {
        heighPicker = TYHeightPicker()
        heighPicker.translatesAutoresizingMaskIntoConstraints = false
        heighPicker.delegate = self
        self.view.addSubview(heighPicker)
        
        heighPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        heighPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        //heighPicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        heighPicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -140).isActive = true
        heighPicker.heightAnchor.constraint(equalToConstant: 145).isActive = true
        
        heighPicker.setDefaultHeight(70, unit: .CM)
    }
}

extension RegistrationViewController: TYHeightPickerDelegate {
    func selectedHeight(height: CGFloat, unit: HeightUnit) {
            weightTextField.text = "\(Int(height))"
    }
}

