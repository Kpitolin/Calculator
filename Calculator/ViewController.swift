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
    @IBOutlet weak var history: UILabel!
    
    var userIsIntheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    
    @IBAction func appendDigit(sender: UIButton) {
        
        
        let digit = sender.currentTitle!
        
        if display.text!.componentsSeparatedByString(".").count == 2 && sender.currentTitle! == "."
        {
            
            UIView.animateWithDuration(5.0, animations:
                {self.display.backgroundColor = UIColor.redColor() },
                completion:
                {(completed: Bool) in if completed{ self.display.backgroundColor = UIColor.whiteColor()}})
            // put the button in red
            
        }
        else if userIsIntheMiddleOfTypingANumber {
            display.text = display.text! + digit
            
        }
            
        else
            
        {
            display.text = digit
            userIsIntheMiddleOfTypingANumber = true
            
        }
        
        history.text = brain.description

        
        
    }
    
    
    /*
    *
    The main purpose of enter is to put the number of the screen in the internal stack
    *
    */
    
    
    @IBAction func enter() {
        
        userIsIntheMiddleOfTypingANumber = false // As the numbers will be put in the start and we start typing a new number, we want them to be cleaned out, to start a new number
        
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
        
    }
    
    // Computed property : it's always being calculated
    
    var displayValue: Double {
        
        get {
            
            var number : Double
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            
        }
        
        set {
            
            display.text = "\(newValue)"
            userIsIntheMiddleOfTypingANumber = false
        }
        
    }
    
    
    
    
    @IBAction func operate(sender: UIButton) {
        
        
        
        if display.text! != "0" && userIsIntheMiddleOfTypingANumber { // Catches the case where operand is the first button touched
            enter() // automatic enter
        }
        
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                
                displayValue = result
                
            } else {
                
                displayValue = 0
                
            }
            
            
        }
    }
    
    
    
    
    @IBAction func erase(sender: UIButton) {
        brain.emptyStack()
        display.text = "0"
        history.text = ""
        userIsIntheMiddleOfTypingANumber = false
        
    }
    

    
    
    
    
}