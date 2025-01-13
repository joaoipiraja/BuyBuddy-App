import SwiftUI

struct AddListView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: ShoppingListViewModel

    // Parâmetro opcional para editar uma lista existente
    private let listToEdit: ShoppingList?

    @State private var listName: String
    @State private var selectedColor: ListColor
    @State private var selectedIcon: ListIcon

    init(viewModel: ShoppingListViewModel, listToEdit: ShoppingList? = nil) {
        self.viewModel = viewModel
        self.listToEdit = listToEdit
        _listName = State(initialValue: listToEdit?.name ?? "")
        _selectedColor = State(initialValue: listToEdit?.color ?? .blue)
        _selectedIcon = State(initialValue: listToEdit?.icon ?? .cart)
    }

    var body: some View {
        NavigationView {
            Form {
                listNameSection
                appearanceSection
            }
            .navigationTitle(title)
            .navigationBarItems(
                leading: cancelButton,
                trailing: saveButton
            )
        }
    }
}

// MARK: - Subviews
private extension AddListView {

    var listNameSection: some View {
        Section(header: Text("Nome da Lista")) {
            TextField("Nome", text: $listName)
        }
    }

    var appearanceSection: some View {
        Section(header: Text("Aparência")) {
            colorPicker
            iconPicker
        }
    }

    var colorPicker: some View {
        Picker("Cor", selection: $selectedColor) {
            ForEach(ListColor.allCases) { color in
                HStack {
                    Circle()
                        .fill(color.color)
                        .frame(width: 20, height: 20)
                    Text(color.rawValue.capitalized)
                }
                .tag(color)
            }
        }
    }

    var iconPicker: some View {
        Picker("Ícone", selection: $selectedIcon) {
            ForEach(ListIcon.allCases) { icon in
                HStack {
                    Image(systemName: icon.systemName)
                        .foregroundColor(.blue)
                    Text(icon.rawValue.capitalized)
                }
                .tag(icon)
            }
        }
    }

    var cancelButton: some View {
        Button("Cancelar") {
            presentationMode.wrappedValue.dismiss()
        }
    }

    var saveButton: some View {
        Button("Salvar") {
            saveAction()
        }
        .disabled(listName.isEmpty)
    }

    var title: String {
        listToEdit == nil ? "Nova Lista" : "Editar Lista"
    }
}

// MARK: - Actions
private extension AddListView {

    func saveAction() {
        if let list = listToEdit {
            var updatedList = list
            updatedList.name = listName
            updatedList.color = selectedColor
            updatedList.icon = selectedIcon
            viewModel.updateList(list: updatedList)
        } else {
            viewModel.addList(name: listName, color: selectedColor, icon: selectedIcon)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

