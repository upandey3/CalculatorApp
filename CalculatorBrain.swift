//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Utkarsh Pandey on 1/12/17.
//  Copyright © 2017 Utkarsh Pandey. All rights reserved.
//

import Foundation

class Queue{
    
    var array:[String?] = [nil, nil]
    func push(val: String)
    {
        if array[0] == nil{
            array[0] = val
        }else {
            array[1] = val
        }
        
    }
    func pop()->(String?){
        if array[0] != nil {
            let s = array[0]
            array[0] = array[1]
            array[1] = nil
            return s
        } else{
            return nil
        }
    }
    func peek()->(String?){
        let s = array[0]
        return s
    }
}

class CalculatorBrain{
    
    private var accumulator = 0.0
    
    var firstOperand: Double?
    var secondOperand: Double?
    //var bsymbol: String = ""
    var csymbol: String?
    var s: String?
    var q : Queue = Queue()
    
    var description: String{
        
        get {
            if csymbol != nil{
                return "\(csymbol!)(\(s!))"
            }
            else if firstOperand == nil {
                return ""
            }else if secondOperand == nil{
                return ("\(firstOperand!) \(q.peek()!/*bsymbol*/) ...")
            }else {
                s = "\(firstOperand!) \(q.pop()!) \(secondOperand!) ="
                //s = "\(firstOperand!) \(bsymbol) \(secondOperand!) ="
                firstOperand = nil
                secondOperand = nil
                //bsymbol = ""
                return s!
            }
        }
    }
    
    var isPartialResult: Bool {
        get {
            if pending != nil {
                return true
            }else{
                return false
            }
        }
    }
    
    var operations: Dictionary<String, Operation> = [
        "e" : Operation.Constant(M_E),
        "π" : Operation.Constant(M_PI),
        "√" : Operation.UnaryOperator(sqrt),
        "cos" : Operation.UnaryOperator(cos),
        "sin" : Operation.UnaryOperator(sin),
        "tan" : Operation.UnaryOperator(tan),
        " x²": Operation.UnaryOperator({pow($0, 2.0)}),
        "×" : Operation.BinaryOperator({$0 * $1}),
        "+" : Operation.BinaryOperator({$0 + $1}),
        "−" : Operation.BinaryOperator({$0 - $1}),
        "÷" : Operation.BinaryOperator({$0 / $1}),
        "=" : Operation.Equals
    ]
    
    enum Operation {
        case Constant(Double)
        case UnaryOperator((Double) -> Double)
        case BinaryOperator((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String){
        if let operation = operations[symbol]{
            switch operation {
            case .Constant (let value): accumulator = value
            case .UnaryOperator (let function): accumulator = function(accumulator)
                                                csymbol = symbol
            case .BinaryOperator(let function) :
                if !isPartialResult{
                    //bsymbol = symbol // Changed
                    firstOperand = accumulator
                    secondOperand = nil
                }
                q.push(val: symbol)
                operate()
                pending = PendingBinaryInfo(firstOperand: accumulator, binaryOperation: function)
            case .Equals : operate()
                
            }
            
        }
    }
    func operate() {
        csymbol = nil
        if pending != nil {
            firstOperand = pending!.firstOperand //
            secondOperand = accumulator //
            accumulator = pending!.binaryOperation(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    private var pending: PendingBinaryInfo?
    
    struct PendingBinaryInfo {
        var firstOperand : Double
        var binaryOperation: (Double, Double) -> Double
    }
    
    var result: Double {
        
        get {
            return accumulator
        }
    }
    
    func setOperand(operand: Double){
        
        accumulator = operand
    }
    
    func clear(){
        accumulator = 0.0
        pending = nil
        //bsymbol = ""
        csymbol = nil
        firstOperand = nil
        secondOperand = nil
        q.array = [nil, nil]
    }
}
