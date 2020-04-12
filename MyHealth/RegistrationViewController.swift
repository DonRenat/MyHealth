//
//  RegistrationViewController.swift
//  MyHealth
//
//  Created by Renat Gasanov on 13.04.2020.
//  Copyright © 2020 Renat Gasanov. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.layer.cornerRadius = 15
        doneButton.layer.cornerCurve = .continuous
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
