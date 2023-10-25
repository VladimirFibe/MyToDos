import SwiftUI
import Combine
class DataStore: ObservableObject {
    @Published var toDos: [ToDo] = [] { didSet { saveToDos() }}
    @Published var appError: ErrorType? = nil { didSet { showAlert = appError != nil }}
    @Published var showAlert = false { didSet { if !showAlert { appError = nil }}}

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

    func loadToDos() {
        do {
            let data = try FileManager().readDocument(docName: fileName)
            let decoder = JSONDecoder()
            toDos = try decoder.decode([ToDo].self, from: data)
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
            try FileManager().saveDocument(contents: jsonString, docName: fileName)
        } catch {
            appError = ErrorType(error: .encodingError)
        }
    }
}
