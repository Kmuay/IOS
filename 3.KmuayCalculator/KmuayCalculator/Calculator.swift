//
//  Calculator.swift
//  KmuayCalculator
//
//  Created by njuios on 2020/10/22.
//

import Foundation

//Stack
struct Stack<Element> {
    var items = [Element]()
    
    //1.push():向栈内压入一个元素
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    //2.pop():将栈顶元素弹出，返回栈顶元素
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    //3.empty():栈为空返回true，不为空返回false
    mutating func empty() -> Bool {
        return items.isEmpty
    }
    
    //4.top():返回栈顶元素，不弹出
    mutating func top() -> Element {
        return items.last!
    }
    
    //5.size():返回栈的大小
    mutating func size() -> Int {
        return items.count
    }
    
    //6.clear():清空栈
    mutating func clear() {
        items.removeAll()
    }
}

//stack for number
var number_stack = Stack<Double>()
//stack for operator
var operator_stack = Stack<String>()

//
var pre_number : Bool = false

var pre_operator : Bool = true

//Tips
//1.AC clear all
//
//for each title
//if it is number as n
//  1.number_stack.push(n)
//  2.combine with x=number_stack.pop() as a new number
//      (1).x*10+n
//      (2).(Double)((String)x+n)
//else it is operator as op
//  1.+-
//  2.*/
//  3.=
//  4..
//
//problem:
//  1.for a int n it will show n.0 as result
//  2.x^y & y√x

func calculator(_ button_title:String) -> String{
    if(button_title == "0" || button_title == "1" || button_title == "2" || button_title == "3" || button_title == "4" || button_title == "5" || button_title == "6" || button_title == "7" || button_title == "8" || button_title == "9"){
        if(pre_operator) {
            if let new_number : Double = Double(button_title) {
                number_stack.push(new_number)
                pre_operator = false
                pre_number = true
            }
        }
        else {
            if(pre_number) {
                if let new_number : Double = Double(button_title) {
                    number_stack.push(number_stack.pop() * 10 + new_number)
                    pre_operator = false
                    pre_number = true
                }
            }
            else {
                var old_number : String = "\(number_stack.pop())"
                old_number += button_title
                if let new_number : Double = Double(old_number) {
                    number_stack.push(new_number)
                }
                pre_operator = false
                pre_number = false
            }
        }
    }
    else if(button_title == "+" || button_title == "-") {
        if(operator_stack.empty()) {
            operator_stack.push(button_title)
        }
        else {
            while(!operator_stack.empty()){
                let op : String = operator_stack.pop()
                let number2 : Double = number_stack.pop()
                let number1 : Double = number_stack.pop()
                if(op == "+") {
                    number_stack.push(number1 + number2)
                }
                else if(op == "-") {
                    number_stack.push(number1 - number2)
                }
                else if(op == "*") {
                    number_stack.push(number1 * number2)
                }
                else if(op == "/") {
                    number_stack.push(number1 / number2)
                }
            }
            operator_stack.push(button_title)
        }
        pre_operator = true
        pre_number = false
    }
    else if(button_title == "*" || button_title == "/") {
        if(operator_stack.empty()) {
            operator_stack.push(button_title)
        }
        else {
            while(!operator_stack.empty()){
                let op : String = operator_stack.pop()
                if(op == "*") {
                    let number2 : Double = number_stack.pop()
                    let number1 : Double = number_stack.pop()
                    number_stack.push(number1 * number2)
                }
                else if(op == "/") {
                    let number2 : Double = number_stack.pop()
                    let number1 : Double = number_stack.pop()
                    number_stack.push(number1 / number2)
                }
                else if(op == "+" || op == "-") {
                    operator_stack.push(op)
                    break
                }
            }
            operator_stack.push(button_title)
        }
        pre_operator = true
        pre_number = false
    }
    else if(button_title == ".") {
        pre_operator = false
        pre_number = false
    }
    else if(button_title == "=") {
        while(!operator_stack.empty()) {
            let op : String = operator_stack.pop()
            let number2 : Double = number_stack.pop()
            let number1 : Double = number_stack.pop()
            if(op == "+") {
                number_stack.push(number1 + number2)
            }
            else if(op == "-") {
                number_stack.push(number1 - number2)
            }
            else if(op == "*") {
                number_stack.push(number1 * number2)
            }
            else if(op == "/") {
                number_stack.push(number1 / number2)
            }
        }
        pre_number = false
        pre_operator = true
        
        let result : Double = number_stack.top()
        return "\(result)"
    }
    else if(button_title == "+/-") {
        let new_number : Double = number_stack.pop() * -1
        number_stack.push(new_number)
    }
    else if(button_title == "%") {
        let new_number : Double = number_stack.pop() / 100
        number_stack.push(new_number)
    }
    else if(button_title == "AC") {
        pre_number = false
        pre_operator = true
        number_stack.clear()
        operator_stack.clear()
        return "0"
    }
    else if(button_title == "x^2") {
        let new_number : Double = pow(number_stack.pop(),2)
        number_stack.push(new_number)
    }
    else if(button_title == "x^3") {
        let new_number : Double = pow(number_stack.pop(),3)
        number_stack.push(new_number)
    }
    else if(button_title == "x^y") {
        //TODO
    }
    else if(button_title == "e^x") {
        let new_number : Double = exp(number_stack.pop())
        number_stack.push(new_number)
    }
    else if(button_title == "10^x") {
        let new_number : Double = pow(10,number_stack.pop())
        number_stack.push(new_number)
    }
    else if(button_title == "1/x") {
        let new_number : Double = 1/number_stack.pop()
        number_stack.push(new_number)
    }
    else if(button_title == "2√x") {
        let new_number : Double = sqrt(number_stack.pop())
        number_stack.push(new_number)
    }
    else if(button_title == "3√x") {
        let new_number : Double = cbrt(number_stack.pop())
        number_stack.push(new_number)
    }
    else if(button_title == "y√x") {
        //TODO
    }
    else if(button_title == "ln") {
        let new_number : Double = log(number_stack.pop())
        number_stack.push(new_number)
    }
    else if(button_title == "log10") {
        let new_number : Double = log10(number_stack.pop())
        number_stack.push(new_number)
    }
    else if(button_title == "x!") {
        var new_number : Double = number_stack.pop()
        var i = new_number - 1
        while(i>1) {
            new_number *= i
            i -= 1
        }
        number_stack.push(new_number)
    }
    else if(button_title == "sin") {
        let new_number : Double = sin(number_stack.pop())
        number_stack.push(new_number)
    }
    else if(button_title == "cos") {
        let new_number :Double = cos(number_stack.pop())
        number_stack.push(new_number)
    }
    else if(button_title == "tan") {
        let new_number : Double = tan(number_stack.pop())
        number_stack.push(new_number)
    }
    else if(button_title == "e") {
        number_stack.push(M_E)
    }
    else if(button_title == "sinh") {
        let new_number : Double = sinh(number_stack.pop())
        number_stack.push(new_number)
    }
    else if(button_title == "cosh") {
        let new_number : Double = cosh(number_stack.pop())
        number_stack.push(new_number)
    }
    else if(button_title == "tanh") {
        let new_number : Double = tanh(number_stack.pop())
        number_stack.push(new_number)
    }
    else if(button_title == "π") {
        number_stack.push(.pi)
    }
    else if(button_title == "Rand") {
        number_stack.push(Double(arc4random()))
    }
    else {
        return "TO BE IMPROVED"
    }
    
    return "\(number_stack.top())"
}
