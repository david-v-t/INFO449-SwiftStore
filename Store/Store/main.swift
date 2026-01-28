//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String { get }
    func price() -> Int
}

class Item: SKU {
    let name: String
    let priceEach: Int
    
    init(name: String, priceEach: Int) {
        self.name = name
        self.priceEach = priceEach
    }
    
    func price() -> Int {
        return priceEach
    }
    
}

class Receipt {
    var scannedItems: [SKU] = []
    
    func add(_ sku: SKU) {
        scannedItems.append(sku)
    }
    
    func items() -> [SKU] {
        return scannedItems
    }
    
    func convert(_ cents: Int) -> String {
        let dollars = Double(cents) / 100.0
        return "$" + String(format: "%.2f", dollars)
    }
    
    func total() -> Int {
        var sum = 0
        for item in scannedItems {
            sum += item.price()
        }
        return sum
    }
    
    func output() -> String {
        var result = "Receipt:\n"
        
        for item in scannedItems {
            result += "\(item.name): \(convert(item.price()))\n"
        }
        result += "------------------\n"
        result += "TOTAL: \(convert(total()))"
        
        return result
    }
    
}

class Register {
    var receipt: Receipt
    
    init() {
        self.receipt = Receipt()
    }
    
    func scan(_ sku: SKU) {
        receipt.add(sku)
    }
    
    func subtotal() -> Int {
        return receipt.total()
    }
    
    func total() -> Receipt {
        let finalReceipt = receipt
        receipt = Receipt()
        
        return finalReceipt
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

