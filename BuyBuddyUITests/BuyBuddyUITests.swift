import XCTest

final class ShoppingListUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments.append("--uitesting") // Opcional: Use isso para configurar o estado inicial
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }
    
    func testCopyButtonDisabledWhenNoItems() {
        // Pré-condição: Criar uma lista sem itens
        createListWithName("Lista Sem Itens")
        
        // Navega para a ShoppingListDetailView
        let listCell = app.staticTexts["Lista Sem Itens"]
        XCTAssertTrue(listCell.exists, "A lista 'Lista Sem Itens' não foi encontrada.")
        listCell.tap()
        
        // Verifica se o botão de copiar está desativado
        let copyButton = app.buttons["CopyButton"]
        XCTAssertTrue(copyButton.exists, "O botão de copiar não foi encontrado.")
        
        // Verifica se o botão está desativado
        XCTAssertFalse(copyButton.isEnabled, "O botão de copiar deveria estar desativado quando não há itens.")
    }
    
    func testCopyButtonEnabledWhenItemsExist() {
        // Pré-condição: Criar uma lista com itens
        createListWithName("Lista Com Itens")
        addItemToList(named: "Arroz", quantity: 2, unit: "kilograms")
        
        // Navega para a ShoppingListDetailView
        let listCell = app.staticTexts["Lista Com Itens"]
        XCTAssertTrue(listCell.exists, "A lista 'Lista Com Itens' não foi encontrada.")
        listCell.tap()
        
        // Verifica se o botão de copiar está ativo
        let copyButton = app.buttons["CopyButton"]
        XCTAssertTrue(copyButton.exists, "O botão de copiar não foi encontrado.")
        
        // Verifica se o botão está ativado
        XCTAssertTrue(copyButton.isEnabled, "O botão de copiar deveria estar ativado quando há itens.")
    }
    
    func testCopyFunctionality() {
        // Pré-condição: Criar uma lista com itens
        createListWithName("Lista para Copiar")
        addItemToList(named: "Leite", quantity: 1, unit: "liters")
        addItemToList(named: "Pão", quantity: 3, unit: "quantity")
        
        // Navega para a ShoppingListDetailView
        let listCell = app.staticTexts["Lista para Copiar"]
        XCTAssertTrue(listCell.exists, "A lista 'Lista para Copiar' não foi encontrada.")
        listCell.tap()
        
        // Toca no botão de copiar
        let copyButton = app.buttons["CopyButton"]
        XCTAssertTrue(copyButton.exists, "O botão de copiar não foi encontrado.")
        XCTAssertTrue(copyButton.isEnabled, "O botão de copiar deveria estar ativado.")
        copyButton.tap()
        
        // Verifica se o alerta de cópia está sendo apresentado
        let copyAlert = app.alerts["Copiado"]
        XCTAssertTrue(copyAlert.waitForExistence(timeout: 2), "O alerta de cópia não apareceu.")
        XCTAssertTrue(copyAlert.staticTexts["A lista foi copiada para a área de transferência."].exists, "A mensagem do alerta está incorreta.")
        copyAlert.buttons["OK"].tap()
    }
    
    // MARK: - Funções auxiliares de teste
    
    private func createListWithName(_ name: String) {
        let addButton = app.buttons["AddListButton"]
        XCTAssertTrue(addButton.exists, "O botão de adicionar lista não foi encontrado.")
        addButton.tap()
        
        let nameField = app.textFields["NomeTextField"]
        XCTAssertTrue(nameField.exists, "O campo de nome não foi encontrado.")
        nameField.tap()
        nameField.typeText(name)
        
        let saveButton = app.buttons["SalvarButton"]
        XCTAssertTrue(saveButton.exists, "O botão de salvar não foi encontrado.")
        saveButton.tap()
        
        // Aguarda a célula com o nome aparecer
        XCTAssertTrue(app.staticTexts[name].waitForExistence(timeout: 2),
                      "Falha ao criar a lista \(name).")
    }
    
    private func addItemToList(named name: String, quantity: Int, unit: String) {
        let addItemButton = app.buttons["AddItemButton"]
        XCTAssertTrue(addItemButton.exists, "O botão de adicionar item não foi encontrado.")
        addItemButton.tap()
        
        let itemNameField = app.textFields["NomeTextField"]
        XCTAssertTrue(itemNameField.exists, "O campo de nome do item não foi encontrado.")
        itemNameField.tap()
        itemNameField.typeText(name)
        
        let quantityField = app.textFields["QuantidadeTextField"]
        XCTAssertTrue(quantityField.exists, "O campo de quantidade não foi encontrado.")
        quantityField.tap()
        quantityField.typeText("\(quantity)")
        
        let unitPicker = app.pickers["UnidadePicker"]
        XCTAssertTrue(unitPicker.exists, "O Picker de unidade não foi encontrado.")
        unitPicker.pickerWheels.element.adjust(toPickerWheelValue: unit)
        
        let saveItemButton = app.buttons["SalvarButton"]
        XCTAssertTrue(saveItemButton.exists, "O botão de salvar item não foi encontrado.")
        saveItemButton.tap()
        
        // Aguarda o item aparecer na lista
        XCTAssertTrue(app.staticTexts[name].waitForExistence(timeout: 2),
                      "Falha ao adicionar o item \(name).")
    }
}

