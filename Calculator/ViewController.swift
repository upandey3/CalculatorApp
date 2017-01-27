//
//  ViewController.swift
//  Calculator
//
//  Created by Utkarsh Pandey on 1/11/17.
//  Copyright © 2017 Utkarsh Pandey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var userIsInTheMiddleOfTyping = false
    private var decimalEntered = false
    
    
    @IBAction private func clearDisplay(_ sender: Any) {
    
        userIsInTheMiddleOfTyping = false
        brain.clear()
        resultField.text = "0"
        equationField.text = ""
        decimalEntered = false
    }
    
    @IBOutlet weak var equationField: UILabel!
    @IBOutlet private weak var resultField: UILabel!
    @IBAction private func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            
            if let display = resultField.text {
                
                if sender.currentTitle == "." && !decimalEntered {
                    decimalEntered = true
                    
                } else if sender.currentTitle == "." && decimalEntered {
                
                    return
                }
                resultField.text = display + digit
            }
            
        } else {
            
            if sender.currentTitle == "."{
                return
            }
            resultField.text = digit
        }
        
        userIsInTheMiddleOfTyping = true
        
    }
    private var brain = CalculatorBrain()
    
    @IBAction private func touchOperand(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
        
            userIsInTheMiddleOfTyping = false
            brain.setOperand(operand: displayVal)
        }
        if let s = sender.currentTitle {
            brain.performOperation(symbol: s)
        }
        displayVal = brain.result
        equationField.text = brain.description
        decimalEntered = false
       
        

    }
    private var displayVal: Double {
        
        get {
            
            if let val = resultField.text {
                
                return Double(val)!
            } else {
                
                return 0.0
            }
        }
        set{
            
            resultField.text = String(newValue)
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

