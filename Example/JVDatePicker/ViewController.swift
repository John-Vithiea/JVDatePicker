//
//  ViewController.swift
//  JVDatePicker
//
//  Created by John Vithiea on 08/26/2021.
//  Copyright (c) 2021 Vithiea Hor All rights reserved.
//

import UIKit
import JVDatePicker

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: UIImage(named: "calendar"))
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        textField.rightView = imageView
        textField.addTarget(self, action: #selector(beginEditing), for: .editingDidBegin)
    }
    
    @objc func beginEditing() {
        let picker = JVDatePicker()
        picker.didPickDate = { date in
            self.textField.text = date.shortDate
        }
        picker.show()
    }
}
