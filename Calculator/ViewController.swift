//
//  ViewController.swift
//  Calculator
//
//  Created by Sonny Kui on 5/5/15.
//  Copyright (c) 2015 SonnyKui. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        
        if (digit == ".") && (display.text!.rangeOfString(".") != nil) { return }
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func backspace() {
        if userIsInTheMiddleOfTypingANumber {
            if (display.text != nil) && (count(display.text!) != 0) {
                display.text = dropLast(display.text!)
                if (display.text == "") {
                    display.text = "0"
                    userIsInTheMiddleOfTypingANumber = false
                }
            }
        }
    }
    
    @IBAction func specialConstant(sender: UIButton) {
        let constant = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        historyStack.insert(constant, atIndex:0)
        switch constant {
        case "π": display.text = "\(M_PI)"
        default: break
        }
        enter()
    }
    
    @IBAction func resetCalculator() {
        userIsInTheMiddleOfTypingANumber = false
        brain.clear()
        //operandStack.removeAll()
        historyStack.removeAll()
        display.text = "0"
        history.text = "0"
        println("reset")
        
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            
            if (operation == "±") {
                if (Array(display.text!)[0] == "-") {
                    display.text = dropFirst(display.text!)
                } else {
                    display.text = "-" + display.text!
                }
                return
            }

            enter()
        }
        //historyStack.append(operation)
        historyStack.insert(operation, atIndex:0)
        if (Array(display.text!)[0] != "=") {
            display.text = "=" + display.text!
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    var historyStack = Array<String>()
    
    @IBAction func enter() {
        if userIsInTheMiddleOfTypingANumber {
            historyStack.insert(display.text!, atIndex:0)
        }
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = nil
        }
        
        history.text = "\(historyStack)"
        
    }
    
    var displayValue: Double? {
        get {
//            if let value = NSNumberFormatter().numberFromString(display.text!)?.doubleValue {
//                return value
//            } else {
//                return nil
//            }
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            display.text = "\(newValue!)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
}

