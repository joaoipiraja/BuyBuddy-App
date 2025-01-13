// AddItemView.swift
import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ShoppingListViewModel
    var list: ShoppingList // Lista à qual o item será adicionado
    
    @State private var name: String = ""
    @State private var quantity: Int = 1
    @State private var selectedUnit: Unit = .quantity
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item")) {
                    TextField("Nome", text: $name)
                    
                    Stepper(value: $quantity, in: 1...100) {
                        Text("Quantidade: \(quantity)")
                    }
                    
                    Picker("Unidade", selection: $selectedUnit) {
                        ForEach(Unit.allCases) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Adicionar Item")
            .navigationBarItems(
                leading: Button("Cancelar") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Salvar") {
                    if !name.isEmpty {
                        viewModel.addItem(to: list, name: name, quantity: quantity, unit: selectedUnit)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(name.isEmpty)
            )
        }
    }
}
