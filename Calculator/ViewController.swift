//
//  ViewController.swift
//  Calculator
//
//  Created by KEVIN on 10/04/2015.
//  Copyright (c) 2015 KEVIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var display: UILabel!
    
    var userIsIntheMiddleOfTypingANumber = false

    @IBAction func appendDigit(sender: UIButton) {
        
        
        let digit = sender.currentTitle!
        
        if userIsIntheMiddleOfTypingANumber {
            display.text = display.text! + digit

        }
            
        else
            
        {
            display.text = digit
            userIsIntheMiddleOfTypingANumber = true

        }
        
        
    }
    
    
    /*
    *
     The main purpose of enter is to put the number of the screen in the internal stack
    *
    */
    var operandStack = Array <Double> ()
    @IBAction func enter() {
        
    userIsIntheMiddleOfTypingANumber = false // As the numbers will be put in the start and we start typing a new number, we want them to be cleaned out, to start a new number
     
    operandStack.append(displayValue)
        
    println("operand Stack = \(operandStack) ")
        
        
    }
    
    // Computed property : it's always being calculated
    
    var displayValue: Double {
        
        get {
            
           return NSNumberFormatter().numberFromString(display.text!)!.doubleValue

        }
        
        set {
            display.text = "\(newValue)"
            userIsIntheMiddleOfTypingANumber = false
        }
        
    }
    
    // The main idea is that we get all the elements typed before the operator that are still in the stack then we 'operate' them
    func performOperation (operation: (Double,Double)->Double ){
        if operandStack.count >= 2
            
        {
            displayValue = operation (operandStack.removeLast(),operandStack.removeLast())
            enter()
        }
    }
    
    

    
    func multiply (op1: Double, op2: Double) ->Double {
        
        return op1*op2
    }
    
    func plus (op1: Double, op2: Double) ->Double {
        
        return op1+op2
    }
    
    func minus (op1: Double, op2: Double) ->Double {
        
        return op1-op2
    }
    
    func divide (op1: Double, op2: Double) ->Double {
        
        if op2 != 0.0 {
         return op1/op2
        }
        return 0.0
    }
    @IBAction func operate(sender: UIButton) {
        
        let operation = sender.currentTitle!
        if userIsIntheMiddleOfTypingANumber {
            enter() // automatic enter
        }
        
        switch operation {
        case "x": performOperation(multiply)
        case "+": performOperation(divide)
        case "÷": performOperation(plus)
        case "-": performOperation(minus)
            
        default: break
            
        }
        
    }
    

    
    

    
    
    
    

}

