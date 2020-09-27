//
//  ViewController.swift
//  Torch
//
//  Created by apple on 2020/9/27.
//  Copyright © 2020 Kmauy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBOutlet var Torch_View: UIView!
    
    @IBOutlet var Torch_Button: UIButton!
    
    @IBAction func changetitle() {
        if Torch_Button.currentTitle == "ON" {
            
            Torch_Button.setTitle("OFF", for: .normal)
            Torch_Button.setTitleColor(.black, for: .normal)
            
            Torch_View.backgroundColor = .white;
        }
        else {
            Torch_Button.setTitle("ON", for: .normal)
            Torch_Button.setTitleColor(.white, for: .normal)
            
            Torch_View.backgroundColor = .black;
        }
    }}

