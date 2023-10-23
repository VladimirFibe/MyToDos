import Foundation

class ToDoFormViewModel: ObservableObject {
    @Published var name = ""
    @Published var comleted = false
    var id: String?

    var updating: Bool {
        id != nil
    }

    var isDisabled: Bool {
        name.isEmpty
    }

    var title: String {
        updating ? "Update" : "Save"
    }

    init () {}

    init(_ currentToDo: ToDo) {
        self.name = currentToDo.name
        self.comleted = currentToDo.completed
        self.id = currentToDo.id
    }
}
