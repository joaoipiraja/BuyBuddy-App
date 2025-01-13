// ShoppingListViewModel.swift
import Foundation
import Combine

class ShoppingListViewModel: ObservableObject {
    @Published var lists: [ShoppingList] = []
    
    private let listsKey = "shopping_lists"
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadLists()
        
        // Salvar automaticamente sempre que houver alterações
        $lists
            .sink { [weak self] lists in
                self?.saveLists()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Lista de Compras
    
    func addList(name: String, color: ListColor, icon: ListIcon) {
        let newList = ShoppingList(name: name, color: color, icon: icon)
        lists.append(newList)
    }
    
    func removeLists(at offsets: IndexSet) {
        lists.remove(atOffsets: offsets)
    }
    
    func updateList(list: ShoppingList) {
        if let index = lists.firstIndex(where: { $0.id == list.id }) {
            lists[index] = list
        }
    }
    
    func duplicateList(_ list: ShoppingList) {
        let duplicatedList = ShoppingList(
            name: list.name + " (Cópia)",
            items: list.items.map { item in
                ShoppingItem(name: item.name, quantity: item.quantity, unit: item.unit)
            }, color: list.color,
            icon: list.icon
        )
        lists.append(duplicatedList)
    }
    
    func getShareContent(for list: ShoppingList) -> String {
        var content = "🛒 *Lista de Compras:* \(list.name)\n\n📝 *Itens:*"
        for item in list.items {
            content += "\n- \(item.name): \(item.quantity) \(item.unit.rawValue.capitalized)"
        }
        return content
    }
    
    // MARK: - Itens da Lista
    
    func addItem(to list: ShoppingList, name: String, quantity: Int, unit: Unit) {
        if let index = lists.firstIndex(where: { $0.id == list.id }) {
            let newItem = ShoppingItem(name: name, quantity: quantity, unit: unit)
            lists[index].items.append(newItem)
        }
    }
    
    func removeItems(from list: ShoppingList, at offsets: IndexSet) {
        if let index = lists.firstIndex(where: { $0.id == list.id }) {
            lists[index].items.remove(atOffsets: offsets)
        }
    }
    
    func updateItem(in list: ShoppingList, item: ShoppingItem) {
        if let listIndex = lists.firstIndex(where: { $0.id == list.id }) {
            if let itemIndex = lists[listIndex].items.firstIndex(where: { $0.id == item.id }) {
                lists[listIndex].items[itemIndex] = item
            }
        }
    }
    
    // MARK: - Persistência
    
    private func loadLists() {
        if let data = UserDefaults.standard.data(forKey: listsKey),
           let decoded = try? JSONDecoder().decode([ShoppingList].self, from: data) {
            self.lists = decoded
        }
    }
    
    private func saveLists() {
        if let encoded = try? JSONEncoder().encode(lists) {
            UserDefaults.standard.set(encoded, forKey: listsKey)
        }
    }
}

