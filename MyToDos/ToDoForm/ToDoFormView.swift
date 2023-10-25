import SwiftUI

struct ToDoFormView: View {
    @EnvironmentObject var dataStore: DataStore
    @ObservedObject var viewModel: ToDoFormViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?

    enum Field {
        case todo
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("ToDo", text: $viewModel.name)
                    .focused($focusedField, equals: .todo)
                Toggle("Comleted", isOn: $viewModel.comleted)
            }
            .navigationTitle("ToDo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { cancelButton }
                ToolbarItem(placement: .topBarTrailing) { saveButton }
                ToolbarItem(placement: .keyboard) { keyboardButton }
            }
            .onTapGesture {
                focusedField = nil
            }
        }
        .task {
            focusedField = .todo
        }
    }
    var keyboardButton: some View {
        Button(action: {
            focusedField = nil
        }) {
            Image(systemName: "keyboard.chevron.compact.down")
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

extension ToDoFormView {
    func updateToDo() {
        guard let id = viewModel.id else { return }
        let toDo = ToDo(
            id: id,
            name: viewModel.name,
            completed: viewModel.comleted
        )
        dataStore.updateToDo(toDo)
        dismiss()
    }

    func addToDo() {
        let toDo = ToDo(name: viewModel.name)
        dataStore.addToDo(toDo)
        dismiss()
    }

    var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }

    var saveButton: some View {
        Button(viewModel.title, action: viewModel.updating ? updateToDo : addToDo)
            .disabled(viewModel.isDisabled)
    }
}
#Preview {
    ToDoFormView(viewModel: ToDoFormViewModel())
        .environmentObject(DataStore())
}
