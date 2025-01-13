import SwiftUI

struct ShoppingListDetailView: View {
    @ObservedObject var viewModel: ShoppingListViewModel
    var list: ShoppingList

    @State private var showingAddItem = false
    @State private var shareContent: String = ""
    @State private var isAnimating = false
    @State private var showingCopyAlert = false

    var body: some View {
        Group {
            if list.items.isEmpty {
                emptyListView
            } else {
                itemListView
            }
        }
        .navigationTitle(list.name)
        .toolbar { toolbarContent }
        .sheet(isPresented: $showingAddItem) {
            AddItemView(viewModel: viewModel, list: list)
        }
        .alert(isPresented: $showingCopyAlert) {
            Alert(
                title: Text("Copiado"),
                message: Text("A lista foi copiada para a área de transferência."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private var emptyListView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .padding()
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .animation(
                    Animation.easeInOut(duration: 1)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
                .onAppear { isAnimating = true }
                .accessibilityIdentifier("EmptyListImage")

            Text("Nenhum item encontrado.")
                .font(.title2)
                .foregroundColor(.gray)
                .accessibilityIdentifier("EmptyListMessage")

            Text("Toque no botão + para adicionar um novo item.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .accessibilityIdentifier("EmptyListInstruction")
        }
        .multilineTextAlignment(.center)
        .padding()
    }

    private var itemListView: some View {
        List {
            ForEach(list.items) { item in
                NavigationLink(destination: EditItemView(viewModel: viewModel, list: list, item: item)) {
                    HStack {
                        Text(item.name)
                            .font(.headline)
                        Spacer()
                        Text("\(item.quantity) \(item.unit.rawValue)")
                            .foregroundColor(.gray)
                    }
                }
            }
            .onDelete { indexSet in
                viewModel.removeItems(from: list, at: indexSet)
            }
        }
    }

    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                copyButton
                addButton
            }
        }
    }

    private var copyButton: some View {
        Button(action: copyListContent) {
            Image(systemName: "doc.on.doc")
                .foregroundColor(list.items.isEmpty ? .gray : .blue)
        }
        .disabled(list.items.isEmpty)
        .accessibilityIdentifier("CopyButton")
    }

    private var addButton: some View {
        Button(action: { showingAddItem = true }) {
            Image(systemName: "plus")
        }
        .accessibilityIdentifier("AddItemButton")
    }

    private func copyListContent() {
        shareContent = viewModel.getShareContent(for: list)
        UIPasteboard.general.string = shareContent
        showingCopyAlert = true
        print("Conteúdo copiado para a área de transferência: \(shareContent)")
    }
}

