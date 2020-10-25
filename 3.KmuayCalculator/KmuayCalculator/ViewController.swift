//
//  ViewController.swift
//  KmuayCalculator
//
//  Created by njuios on 2020/10/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var Output: UILabel!
    
    @IBOutlet weak var e_y: UIButton!
    @IBOutlet weak var y_10: UIButton!
    @IBOutlet weak var ln_log: UIButton!
    @IBOutlet weak var log_10_2: UIButton!
    @IBOutlet weak var sin: UIButton!
    @IBOutlet weak var cos: UIButton!
    @IBOutlet weak var tan: UIButton!
    @IBOutlet weak var sinh: UIButton!
    @IBOutlet weak var cosh: UIButton!
    @IBOutlet weak var tanh: UIButton!
    
    @IBAction func Touch_Button(_ sender: UIButton) {
        
        //TODO
        //Output.text = func(sender.title);
        //该func实现计算器功能
        //输入：按键上的title
        //输出：此次touch行为后，label显示的内容
        if(sender.currentTitle == "2nd") {
            if(e_y.currentTitle == "e^x") {
                e_y.setTitle("y^x", for: .normal)
            }
            else {
                e_y.setTitle("e^x", for: .normal)
            }
            
            if(y_10.currentTitle == "10^x") {
                y_10.setTitle("2^x", for: .normal)
            }
            else {
                y_10.setTitle("10^x", for: .normal)
            }
            
            if(ln_log.currentTitle == "ln") {
                ln_log.setTitle("logy", for: .normal)
            }
            else {
                ln_log.setTitle("ln", for: .normal)
            }
            
            if(log_10_2.currentTitle == "log10") {
                log_10_2.setTitle("log2", for: .normal)
            }
            else {
                log_10_2.setTitle("log10", for: .normal)
            }
            
            if(sin.currentTitle == "sin") {
                sin.setTitle("sin^-1", for: .normal)
            }
            else {
                sin.setTitle("sin", for: .normal)
            }
            
            if(cos.currentTitle == "cos") {
                cos.setTitle("cos^-1", for: .normal)
            }
            else {
                cos.setTitle("cos", for: .normal)
            }
            
            if(tan.currentTitle == "tan") {
                tan.setTitle("tan^-1", for: .normal)
            }
            else {
                tan.setTitle("tan", for: .normal)
            }
            
            if(sinh.currentTitle == "sinh") {
                sinh.setTitle("sinh^-1", for: .normal)
            }
            else {
                sinh.setTitle("sinh", for: .normal)
            }
            
            if(cosh.currentTitle == "cosh") {
                cosh.setTitle("cosh^-1", for: .normal)
            }
            else {
                cosh.setTitle("cosh", for: .normal)
            }
            
            if(tanh.currentTitle == "tanh") {
                tanh.setTitle("tanh^-1", for: .normal)
            }
            else {
                tanh.setTitle("tanh", for: .normal)
            }
        }
        else {
            Output.text = calculator(sender.currentTitle ?? "Blank")
        }
    }
}

