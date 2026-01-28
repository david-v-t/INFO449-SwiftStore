//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testSingleItemSubTotal() {
        register.scan(Item(name: "Beans", priceEach: 399))
        XCTAssertEqual(register.subtotal(), 399)
    }
    
    func testReceiptClearsAfterTotal() {
        register.scan(Item(name: "Beans", priceEach: 399))
        register.scan(Item(name: "Bananas", priceEach: 199))
        
        let receipt = register.total()
        XCTAssertEqual(receipt.items().count, 2)
        XCTAssertEqual(receipt.total(), 399 + 199)

        XCTAssertEqual(register.subtotal(), 0)
        
        let emptyReceipt = register.total()
        XCTAssertEqual(emptyReceipt.items().count, 0)
        XCTAssertEqual(emptyReceipt.total(), 0)
    }
    
    func testNoItems() {
        XCTAssertEqual(register.subtotal(), 0)
        
        let receipt = register.total()
        XCTAssertEqual(receipt.items().count, 0)
        
        let expectedReceipt = """
Receipt:
------------------
TOTAL: $0.00
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testZeroPriceItem() {
        
        register.scan(Item(name: "Stickers", priceEach: 0))
        XCTAssertEqual(register.subtotal(), 0)
        
        let receipt = register.total()
        let expectedReceipt = """
Receipt:
Stickers: $0.00
------------------
TOTAL: $0.00
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
}
