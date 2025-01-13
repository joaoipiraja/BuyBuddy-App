//
//  ShoppingItem.swift
//  BuyBuddy
//
//  Created by João Victor Ipirajá de Alencar on 08/01/25.
//

import Foundation

struct ShoppingItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var quantity: Int
    var unit: Unit
    
    init(id: UUID = UUID(), name: String, quantity: Int = 1, unit: Unit = .quantity) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }
    
    // Método para criar uma cópia do item
        func copy() -> ShoppingItem {
            return ShoppingItem(id: UUID(), name: self.name, quantity: self.quantity, unit: self.unit)
        }
}

