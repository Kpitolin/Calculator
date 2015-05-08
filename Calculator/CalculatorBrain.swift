//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by KEVIN on 18/04/2015.
//  Copyright (c) 2015 KEVIN. All rights reserved.
//

import Foundation




class CalculatorBrain {
    
    
    private enum Op : Printable {
        
        case Operand (Double)
        case UnaryOperation (String, Double->Double)
        case BinaryOperation (String, (Double, Double)->Double)
        
        
        var description : String {
            get{
                switch self {
                case .Operand(let operand) : return "\(operand)"
                case .UnaryOperation(let symbol, _): return symbol
                case .BinaryOperation(let symbol, _): return symbol
                    
                }
            }
            
        }
    }
    
    var description: String? {
        
        get {
            if let descr = interprete(opStack).description {
                return descr
            }
            return nil
        }
    }
    
    private var opStack = [Op]()  // stack of both operands and operators
    private var knownOps = [String:Op]()
    
    
    // Initializer
    
    init(){
        
        
        func learnOp (op : Op){
            knownOps [op.description] =  op
        }
        
        learnOp (Op.BinaryOperation("x", *))
        learnOp (Op.BinaryOperation("÷"){$1 / $0})
        learnOp (Op.BinaryOperation("+", +))
        learnOp (Op.BinaryOperation("-"){$1 - $0})
        learnOp (Op.UnaryOperation("√", sqrt))
        learnOp (Op.UnaryOperation("cos", cos))
        learnOp (Op.UnaryOperation("sin", sin))
        
        
    }
    
    private func interprete(ops: [Op]) -> (description: String?, remainingOps: [Op]){
        
        if !ops.isEmpty
        {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op{
                
            case .Operand:
                
                if remainingOps.count>3{
                    
                    // on met op au début de remainingOps
                    remainingOps.insert(op, atIndex: 0)
                    
                    let (stringDescription,rOps) = interprete(remainingOps)
                    
                    if  (stringDescription != nil) {
                        println("\(opStack) with \(rOps) left over")

                        return  ( "(" + stringDescription! + ")",rOps)
                    }
                    
                }
                println("\(opStack) with \(remainingOps) left over")

                return  (op.description,remainingOps)
                
                //}
            case .UnaryOperation:
                
                let (stringDescription,rOps) = interprete(remainingOps)
                
                if (stringDescription != nil){
                    
                    
                    println("\(opStack) with \(rOps) left over")

                    return (op.description + "(" + stringDescription! + ")", rOps)
                    
                }
                
                
                
            case .BinaryOperation:
                
                
                //appel récursif op gauche
                
                let (operandRight,rOps) = interprete(remainingOps)
                if (operandRight != nil){
                    
                    let (operandLeft,rOps2) = interprete(rOps)
                    if (operandLeft != nil){
                        println("\(opStack) with \(rOps2) left over")

                        return ((operandLeft! + op.description + operandRight!) , rOps2)
                        
                    }
                    
                }
                
            }
        }
        
        println("nil reached")

        return (nil, ops)
        
        
    }
    
    
    
    // unseen let
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        
        if !ops.isEmpty
        {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
                
                
            case .Operand(let operand) : return (operand,remainingOps)
                
            case .UnaryOperation(_, let operation) :
                
                let operandEvaluation = evaluate(remainingOps)
                
                if let operand = operandEvaluation.result {
                    
                    return (operation(operand), operandEvaluation.remainingOps)
                    
                    
                }
                
                
                
            case .BinaryOperation(_, let operation) :
                
                // prendre la gauche puis la droite
                
                let operandEvaluationLeft = evaluate(remainingOps)
                
                if let operandLeft = operandEvaluationLeft.result{
                    let operandEvaluationRight = evaluate(operandEvaluationLeft.remainingOps)
                    
                    if let operandRight = operandEvaluationRight.result{
                        
                        return (operation(operandLeft,operandRight), operandEvaluationRight.remainingOps)
                        
                    }
                    
                }
                
            }
            
        }
        
        
        return (nil,ops)
    }
    
    // If you can't evaluate -> you return nil
    
    func evaluate () -> Double? {
        
        let (result,remainder) = evaluate(opStack)
        return result
        
    }
    
    func emptyStack () {
        opStack.removeAll(keepCapacity:false)
    }
    
    func pushOperand (operand:  Double) -> Double? {
        
        opStack.append(.Operand(operand))
        return evaluate()
        
    }
    
    
    func performOperation (symbol: String) -> Double? {
        
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        
        return evaluate()
        
    }
    
    
}








