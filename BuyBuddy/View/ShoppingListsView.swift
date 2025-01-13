import SwiftUI

struct ShoppingListsView: View {
    @StateObject private var viewModel = ShoppingListViewModel()
    @State private var showingAddList = false
    @State private var listToEdit: ShoppingList? = nil
    @Environment(\.editMode) var editMode

    var body: some View {
        NavigationView {
            Group {
                if viewModel.lists.isEmpty {
                    emptyPlaceholderView
                } else {
                    shoppingListsView
                }
            }
            .navigationTitle("Minhas Listas")
            .navigationBarItems(leading: EditButton().accessibilityIdentifier("EditButton"),
                                trailing: addButton)
            .sheet(isPresented: $showingAddList) {
                if let listToEdit = listToEdit {
                    AddListView(viewModel: viewModel, listToEdit: listToEdit)
                } else {
                    AddListView(viewModel: viewModel)
                }
            }
        }
    }

    private var emptyPlaceholderView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .padding()

            Text("Nenhuma lista de compras encontrada.")
                .font(.title2)
                .foregroundColor(.gray)

            Text("Toque no botão + para criar uma nova lista.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding()
    }

    private var shoppingListsView: some View {
        List {
            ForEach(viewModel.lists) { list in
                if editMode?.wrappedValue == .active {
                    editableListCell(for: list)
                } else {
                    defaultListCell(for: list)
                }
            }
            .onDelete(perform: viewModel.removeLists)
            .onMove(perform: moveList)
        }
    }

    private func editableListCell(for list: ShoppingList) -> some View {
        HStack {
            Image(systemName: list.icon.systemName)
                .foregroundColor(list.color.color)
                .font(.title2)
            VStack(alignment: .leading) {
                Text(list.name)
                    .font(.headline)
                Text("\(list.items.count) itens")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            listToEdit = list
            showingAddList = true
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            deleteButton(for: list)
        }
    }

    private func defaultListCell(for list: ShoppingList) -> some View {
        NavigationLink(destination: ShoppingListDetailView(viewModel: viewModel, list: list)) {
            HStack {
                Image(systemName: list.icon.systemName)
                    .foregroundColor(list.color.color)
                    .font(.title2)
                VStack(alignment: .leading) {
                    Text(list.name)
                        .font(.headline)
                    Text("\(list.items.count) itens")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            duplicateButton(for: list)
            editButton(for: list)
            deleteButton(for: list)
        }
    }

    private var addButton: some View {
        Button(action: {
            listToEdit = nil
            showingAddList = true
        }) {
            Image(systemName: "plus")
        }
        .accessibilityIdentifier("AddButton")
    }

    private func duplicateButton(for list: ShoppingList) -> some View {
        Button {
            viewModel.duplicateList(list)
        } label: {
            Label("Duplicar", systemImage: "doc.on.doc")
        }
        .tint(.gray)
    }

    private func editButton(for list: ShoppingList) -> some View {
        Button {
            listToEdit = list
            showingAddList = true
        } label: {
            Label("Editar", systemImage: "pencil")
        }
        .tint(.blue)
    }

    private func deleteButton(for list: ShoppingList) -> some View {
        Button(role: .destructive) {
            if let index = viewModel.lists.firstIndex(where: { $0.id == list.id }) {
                viewModel.lists.remove(at: index)
            }
        } label: {
            Label("Excluir", systemImage: "trash")
        }
    }

    private func moveList(from source: IndexSet, to destination: Int) {
        viewModel.lists.move(fromOffsets: source, toOffset: destination)
    }
}

