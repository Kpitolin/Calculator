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
    
    var userIsIntheMiddleOfTypingANumber: Bool = false

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
        
        
        println("digit = \(digit)")
    }

}

