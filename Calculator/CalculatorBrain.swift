//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by KEVIN on 18/04/2015.
//  Copyright (c) 2015 KEVIN. All rights reserved.
//

import Foundation

// variable operand



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
    
    
    
    private var opStack = [Op]()  // stack of both operands and operators
    private var knownOps = [String:Op]()
    
    
    // Initializer
    
    init (){
        
        
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
    
    
    // If you can't evaluate -> you return nil
    
    func evaluate () -> Double? {
        
      let (result,remainder) = evaluate(opStack)
        println("\(opStack) with \(remainder) left over")
        return result
        
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
    
    
    
}