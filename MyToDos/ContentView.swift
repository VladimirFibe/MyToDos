import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var modalType: ModalType? = nil
    var body: some View {
        NavigationStack {
            List {
                ForEach(dataStore.toDos) { todo in
                    Button(action: {
                        modalType = .update(todo)
                    }) {
                        Text(todo.name)
                            .font(.title3)
                            .strikethrough(todo.completed)
                        .foregroundStyle(todo.completed ? .green : Color(.label))
                    }
                }
                .onDelete(perform: dataStore.deleteToDo)
            }
            .task {
                if FileManager().docExist(named: fileName) {
                    dataStore.loadToDos()
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("My ToDos")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        modalType = .new
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .foregroundStyle(.red)
        }
        .sheet(item: $modalType) { $0 }
        .alert(
            "File Error",
            isPresented: $dataStore.showAlert,
            presenting: dataStore.appError
        ) { $0.button } message: { Text($0.message) }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataStore())
}
