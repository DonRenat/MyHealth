//
//  ChatVC.swift
//  MyHealth
//
//  Created by Renat Gasanov on 21.06.2020.
//  Copyright © 2020 Renat Gasanov. All rights reserved.
//

import UIKit
import SocketIO

let manager = SocketManager(socketURL: URL(string: "http://192.168.0.15:3000")!, config: [.log(true), .compress])
let socket = manager.defaultSocket

class ChatVC: UIViewController {
    
    @IBOutlet weak var chatView: UITextView!
    @IBOutlet weak var sendField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHandlers()
        socket.connect()
    }
    
    @IBAction func send(_ sender: Any) {
        socket.emit("chat message", [self.sendField.text!])
        self.chatView.text?.append(self.sendField.text! + "\n")
        self.sendField.text = ""
    }
    
    func addHandlers() {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }

        socket.on("chat message") {[weak self] data, ack in
            if let value = data.first as? String {
                self?.chatView.text?.append(value + "\n")
            }
        }
    }

}
