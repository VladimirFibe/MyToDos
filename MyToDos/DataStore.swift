import SwiftUI
import Observation

@Observable
class DataStore {
    var toDos: [ToDo] = [] { didSet { saveToDos() }}
    var appError: ErrorType? = nil { didSet { showAlert = appError != nil }}
    var showAlert = false { didSet { if !showAlert { appError = nil }}}
    var filterText = "" {
        didSet {
            if !filterText.isEmpty {
                filteredToDos = toDos.filter { $0.name.lowercased().contains(filterText.lowercased())}
            } else {
                filteredToDos = toDos
            }
        }
    }
    var filteredToDos: [ToDo] = []
    
    func newToDo() {
        addToDo(ToDo(name: ""))
    }
    
    func addToDo(_ toDo: ToDo) {
        toDos.append(toDo)
    }

    func updateToDo(_ toDo: ToDo) {
        guard let index = toDos.firstIndex(where: { $0.id == toDo.id}) else { return }
        toDos[index] = toDo
    }

    func deleteToDo(at indexSet: IndexSet) {
        toDos.remove(atOffsets: indexSet)
    }

    func deleteToDo(_ toDo: ToDo) {
        guard let index = toDos.firstIndex(where: { $0.id == toDo.id }) else { return }
        toDos.remove(at: index)
    }

    func toggleToDo(_ toDo: ToDo) {
        guard let index = toDos.firstIndex(where: { $0.id == toDo.id }) else { return }
        toDos[index].completed.toggle()
    }

    func loadToDos() {
        do {
            let data = try FileManager().readDocument()
            let decoder = JSONDecoder()
            toDos = try decoder.decode([ToDo].self, from: data)
            filteredToDos = toDos
        } catch {
            appError = ErrorType(error: .decodingError)
        }
    }

    func saveToDos() {
        print("Saving toDos to file system")
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(toDos)
            let jsonString = String(decoding: data, as: UTF8.self)
            try FileManager().saveDocument(contents: jsonString)
        } catch {
            appError = ErrorType(error: .encodingError)
        }
    }
}
