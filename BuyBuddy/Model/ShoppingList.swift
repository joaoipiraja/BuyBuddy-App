//
//  ShoppingList.swift
//  BuyBuddy
//
//  Created by João Victor Ipirajá de Alencar on 08/01/25.

import Foundation
import SwiftUI

struct ShoppingList: Identifiable, Codable {
    let id: UUID
    var name: String
    var items: [ShoppingItem]
    var color: ListColor
    var icon: ListIcon
    
    init(id: UUID = UUID(), name: String, items: [ShoppingItem] = [], color: ListColor = .blue, icon: ListIcon = .cart) {
        self.id = id
        self.name = name
        self.items = items
        self.color = color
        self.icon = icon
    }
}

