import XCTest
@testable import BuyBuddy

final class ShoppingListViewModelTests: XCTestCase {
    
    var viewModel: ShoppingListViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Instancia o ViewModel antes de cada teste
        viewModel = ShoppingListViewModel()
        
        // Limpa as listas para garantir que cada teste comece do zero
        viewModel.lists.removeAll()
    }
    
    override func tearDownWithError() throws {
        // Define o ViewModel como nil após cada teste
        viewModel = nil
        
        try super.tearDownWithError()
    }
    
    func testAddList() throws {
        // Dado que não há listas no início
        XCTAssertEqual(viewModel.lists.count, 0)
        
        // Quando adiciono uma nova lista
        viewModel.addList(name: "Mercado", color: .red, icon: .cart)
        
        // Então deve haver 1 lista adicionada
        XCTAssertEqual(viewModel.lists.count, 1)
        XCTAssertEqual(viewModel.lists.first?.name, "Mercado")
        XCTAssertEqual(viewModel.lists.first?.color, .red)
        XCTAssertEqual(viewModel.lists.first?.icon, .cart)
    }
    
    func testRemoveList() throws {
        // Dado que temos duas listas
        viewModel.addList(name: "Mercado", color: .blue, icon: .basket)
        viewModel.addList(name: "Farmácia", color: .green, icon: .bag)
        XCTAssertEqual(viewModel.lists.count, 2)
        
        // Captura o primeiro ID
        let firstListID = viewModel.lists[0].id
        
        // Quando removo a primeira lista
        if let index = viewModel.lists.firstIndex(where: { $0.id == firstListID }) {
            viewModel.lists.remove(at: index)
        }
        
        // Então deve restar 1 lista
        XCTAssertEqual(viewModel.lists.count, 1)
        XCTAssertEqual(viewModel.lists.first?.name, "Farmácia")
    }
    
    func testUpdateList() throws {
        // Dado que tenho uma lista
        viewModel.addList(name: "Padaria", color: .yellow, icon: .cartFill)
        guard let originalList = viewModel.lists.first else {
            XCTFail("Nenhuma lista foi adicionada.")
            return
        }
        
        // Quando atualizo a lista
        var updatedList = originalList
        updatedList.name = "Padaria Nova"
        updatedList.color = .purple
        
        viewModel.updateList(list: updatedList)
        
        // Então as alterações devem estar refletidas
        guard let newList = viewModel.lists.first else {
            XCTFail("A lista atualizada não foi encontrada.")
            return
        }
        
        XCTAssertEqual(newList.name, "Padaria Nova")
        XCTAssertEqual(newList.color, .purple)
        XCTAssertEqual(newList.icon, .cartFill, "O ícone original deve permanecer inalterado")
    }
    
    func testAddItemToList() throws {
        // Dado que tenho uma lista e ela está vazia
        viewModel.addList(name: "Mercado", color: .blue, icon: .cart)
        guard let list = viewModel.lists.first else {
            XCTFail("Lista não criada.")
            return
        }
        XCTAssertEqual(list.items.count, 0)
        
        // Quando adiciono um item
        viewModel.addItem(to: list, name: "Arroz", quantity: 2, unit: .kilograms)
        
        // Então devo ter 1 item na lista
        let updatedList = viewModel.lists.first
        XCTAssertEqual(updatedList?.items.count, 1)
        XCTAssertEqual(updatedList?.items.first?.name, "Arroz")
        XCTAssertEqual(updatedList?.items.first?.quantity, 2)
        XCTAssertEqual(updatedList?.items.first?.unit, .kilograms)
    }
    
    func testRemoveItemsFromList() throws {
        // Dado que tenho uma lista com 2 itens
        viewModel.addList(name: "Frutas", color: .green, icon: .basketFill)
        guard var fruitList = viewModel.lists.first else {
            XCTFail("Lista não criada.")
            return
        }
        viewModel.addItem(to: fruitList, name: "Maçã", quantity: 4, unit: .quantity)
        viewModel.addItem(to: fruitList, name: "Banana", quantity: 6, unit: .quantity)
        fruitList = viewModel.lists.first!
        XCTAssertEqual(fruitList.items.count, 2)
        
        // Quando removo o primeiro item
        let indexSet = IndexSet(integer: 0)
        viewModel.removeItems(from: fruitList, at: indexSet)
        
        // Então deve sobrar 1 item
        let updatedList = viewModel.lists.first
        XCTAssertEqual(updatedList?.items.count, 1)
        XCTAssertEqual(updatedList?.items.first?.name, "Banana")
    }
    
    func testUpdateItem() throws {
        // Dado que tenho uma lista com 1 item
        viewModel.addList(name: "Limpeza", color: .purple, icon: .star)
        guard let cleaningList = viewModel.lists.first else {
            XCTFail("Lista não criada.")
            return
        }
        viewModel.addItem(to: cleaningList, name: "Detergente", quantity: 1, unit: .grams)
        
        // Quando atualizo esse item
        guard let item = viewModel.lists.first?.items.first else {
            XCTFail("Item não encontrado.")
            return
        }
        var updatedItem = item
        updatedItem.name = "Detergente Líquido"
        updatedItem.quantity = 2
        updatedItem.unit = .liters
        
        viewModel.updateItem(in: cleaningList, item: updatedItem)
        
        // Então as alterações devem estar refletidas
        guard let newItem = viewModel.lists.first?.items.first else {
            XCTFail("Item atualizado não encontrado.")
            return
        }
        
        XCTAssertEqual(newItem.name, "Detergente Líquido")
        XCTAssertEqual(newItem.quantity, 2)
        XCTAssertEqual(newItem.unit, .liters)
    }
    
    func testDuplicateList() throws {
        // Dado que temos uma lista com 2 itens
        viewModel.addList(name: "Mercado", color: .blue, icon: .cart)
        guard let originalList = viewModel.lists.first else {
            XCTFail("Lista original não foi adicionada.")
            return
        }
        viewModel.addItem(to: originalList, name: "Leite", quantity: 2, unit: .liters)
        viewModel.addItem(to: originalList, name: "Pão", quantity: 5, unit: .quantity)
        XCTAssertEqual(viewModel.lists.count, 1)
        XCTAssertEqual(viewModel.lists.first?.items.count, 2)
        
        // Quando duplicamos a lista
        viewModel.duplicateList(originalList)
        
        // Então deve haver duas listas
        XCTAssertEqual(viewModel.lists.count, 2)
        
        // Verifica a lista duplicada
        let duplicatedList = viewModel.lists.last!
        XCTAssertEqual(duplicatedList.name, "Mercado (Cópia)")
        XCTAssertEqual(duplicatedList.color, .blue)
        XCTAssertEqual(duplicatedList.icon, .cart)
        XCTAssertEqual(duplicatedList.items.count, 2)
        XCTAssertEqual(duplicatedList.items[0].name, "Leite")
        XCTAssertEqual(duplicatedList.items[1].name, "Pão")
    }
}


