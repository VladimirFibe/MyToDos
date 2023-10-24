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
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My ToDos")
                        .font(.largeTitle)
                }
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
        .alert(item: $dataStore.appError) {
            Alert(title: Text("Oh Oh"), message: Text($0.error.localizedDescription))
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataStore())
}
