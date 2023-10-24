import SwiftUI

struct ToDoFormView: View {
    @EnvironmentObject var dataStore: DataStore
    @ObservedObject var viewModel: ToDoFormViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                TextField("ToDo", text: $viewModel.name)
                Toggle("Comleted", isOn: $viewModel.comleted)
            }
            .navigationTitle("ToDo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { cancelButton }
                ToolbarItem(placement: .topBarTrailing) { saveButton }
            }
        }
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
        dataStore.updateToDo.send(toDo)
        dismiss()
    }

    func addToDo() {
        let toDo = ToDo(name: viewModel.name)
        dataStore.addToDo.send(toDo)
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
