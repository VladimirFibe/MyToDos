import SwiftUI

struct ContentView: View {
    @Environment(DataStore.self) var dataStore
    @State private var modalType: ModalType? = nil
    @FocusState private var focusedToDo: Bool?

    var body: some View {
        @Bindable var dataStore = dataStore
        NavigationStack {
            List {
                ForEach($dataStore.filteredToDos) { $todo in
                    VStack {
                        if todo.completed {
                            Text(todo.name)
                                .strikethrough()
                                .foregroundStyle(.green)
                        } else {

                            TextField(todo.name, text: $todo.name)
                                .foregroundStyle(Color(.label))
                                .focused($focusedToDo, equals: true)
                        }
                    }
                    .font(.title3)
                    .foregroundStyle(todo.completed ? .green : Color(.label))
                    .swipeActions {
                        Button(role: .destructive) {
                            dataStore.deleteToDo(todo)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button {
                            print("change modaltype")
                            modalType = .update(todo)
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            todo.completed.toggle()
                        } label: {
                            Text(todo.completed ? "Remove Completion" : "Comleted")
                        }
                        .tint(.teal)
                    }
                }
            }
            .task {
                if FileManager().docExist() {
                    dataStore.loadToDos()
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("My ToDos")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { addButton }
                ToolbarItem(placement: .keyboard) { keyboardButton }
            }
            .foregroundStyle(.red)
        }
        .onTapGesture {
            focusedToDo = nil
        }
        .sheet(item: $modalType) { $0 }
        .searchable(text: $dataStore.filterText, prompt: Text("Filter ToDos"))
        .alert(
            "File Error",
            isPresented: $dataStore.showAlert,
            presenting: dataStore.appError
        ) { $0.button } message: { Text($0.message) }
    }

    var addButton: some View {
        Button(action: dataStore.newToDo) {
            Image(systemName: "plus.circle.fill")
        }
    }

    var keyboardButton: some View {
        Button(action: {
            focusedToDo = nil
        }) {
            Image(systemName: "keyboard.chevron.compact.down")
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

#Preview {
    ContentView()
        .environment(DataStore())
}
