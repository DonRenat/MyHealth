//
//  ChatVC.swift
//  MyHealth
//
//  Created by Renat Gasanov on 21.06.2020.
//  Copyright © 2020 Renat Gasanov. All rights reserved.
//

import UIKit
import SocketIO
import Foundation

let manager = SocketManager(socketURL: URL(string: "http://192.168.1.78:4000/")!, config: [.log(true), .compress])
let socket = manager.defaultSocket

let name = UserDefaults.standard.string(forKey: "NameKey")
let fam = UserDefaults.standard.string(forKey: "FamKey")
let SN = UserDefaults.standard.string(forKey: "SNKey")

class ChatVC: UIViewController {
    
    @IBOutlet weak var chatView: UITextView!
    @IBOutlet weak var sendField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.cornerRadius = 10
        sendButton.layer.cornerCurve = .continuous
        
        addHandlers()
        socket.connect()
    }
    
    @IBAction func send(_ sender: Any) {
        let text = name! + ":" + SN! + ":" + self.sendField.text!
        print(text)
        socket.emit("chat message", text)
        //socket.emit("chat message", [name!, self.sendField.text!])
        //self.chatView.text?.append(name! + ": " + self.sendField.text! + "\n")
        self.sendField.text = ""
    }
    
    func addHandlers() {
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }

        socket.on("chat message") {[weak self] data, ack in
            if let value = data.first as? String {
                let separate: String = value
                let separatedArr = separate.components(separatedBy: ":")
                if separatedArr[1] ?? "" == SN {
                    self?.chatView.text?.append(separatedArr[0] + ": " + separatedArr[2] + "\n")
                }
                //self?.chatView.text?.append(separatedArr[1] + "\n")
            }
        }
    }

}
