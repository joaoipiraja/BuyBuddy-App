
// ListAppearance.swift
import SwiftUI

enum ListColor: String, CaseIterable, Codable, Identifiable {
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
    case pink
    case gray
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
        case .pink: return .pink
        case .gray: return .gray
        }
    }
}

enum ListIcon: String, CaseIterable, Codable, Identifiable {
    case cart
    case basket
    case bag
    case cartFill = "cart.fill"
    case basketFill = "basket.fill"
    case bagFill = "bag.fill"
    case checkmark
    case star
    
    var id: String { self.rawValue }
    
    var systemName: String {
        switch self {
        case .cart: return "cart"
        case .basket: return "basket"
        case .bag: return "bag"
        case .cartFill: return "cart.fill"
        case .basketFill: return "basket.fill"
        case .bagFill: return "bag.fill"
        case .checkmark: return "checkmark.circle"
        case .star: return "star"
        }
    }
}


enum Unit: String, CaseIterable, Codable, Identifiable {
    case quantity = "Quantidade"
    case grams = "g"
    case kilograms = "kg"
    case liters = "L"
    
    var id: String { self.rawValue }
}
