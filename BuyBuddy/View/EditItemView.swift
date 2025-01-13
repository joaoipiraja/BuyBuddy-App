//
//  EditItemView.swift
//  BuyBuddy
//
//  Created by João Victor Ipirajá de Alencar on 08/01/25.
//

import SwiftUI

struct EditItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ShoppingListViewModel
    var list: ShoppingList // Lista à qual o item pertence
    @State var item: ShoppingItem
    
    var body: some View {
        Form {
            Section(header: Text("Item")) {
                TextField("Nome", text: $item.name)
                
                Stepper(value: $item.quantity, in: 1...100) {
                    Text("Quantidade: \(item.quantity)")
                }
                
                Picker("Unidade", selection: $item.unit) {
                    ForEach(Unit.allCases) { unit in
                        Text(unit.rawValue).tag(unit)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .navigationTitle("Editar Item")
        .navigationBarItems(
            trailing: Button("Salvar") {
                if !item.name.isEmpty {
                    viewModel.updateItem(in: list, item: item)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .disabled(item.name.isEmpty)
        )
    }
}
