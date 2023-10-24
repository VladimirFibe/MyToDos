import SwiftUI
import Combine
class DataStore: ObservableObject {
    @Published var toDos: [ToDo] = []
    @Published var appError: ErrorType? = nil
    var subscriptions = Set<AnyCancellable>()
    var addToDo = PassthroughSubject<ToDo, Never>()
    var updateToDo = PassthroughSubject<ToDo, Never>()
    var deleteToDo = PassthroughSubject<IndexSet, Never>()
    var loadToDo = Just(FileManager.docDirURL.appendingPathComponent(fileName))

    init() {
        print(FileManager.docDirURL.path)
        addSubscriptions()
    }

    func addSubscriptions() {

        loadToDo
            .filter { FileManager.default.fileExists(atPath: $0.path)}
            .tryMap { url in
                try Data(contentsOf: url)
            }
            .decode(type: [ToDo].self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                switch $0 {
                case .finished: print("Loading")
                    toDosSubscription()
                case .failure(let error):
                    if error is ToDoError {
                        appError = ErrorType(error: error as! ToDoError)
                    } else {
                        appError = ErrorType(error: .decodingError)
                        toDosSubscription()
                    }
                }
            } receiveValue: {
                self.toDos = $0
            }
            .store(in: &subscriptions)

        addToDo
            .sink {[unowned self]  in
                toDos.append($0)
            }
            .store(in: &subscriptions)

        updateToDo
            .sink { [unowned self] toDo in
                guard let index = toDos.firstIndex(where: {$0.id == toDo.id}) else { return }
                toDos[index] = toDo
            }
            .store(in: &subscriptions)

        deleteToDo
            .sink { [unowned self] indexSet in
                toDos.remove(atOffsets: indexSet)
            }
            .store(in: &subscriptions)
    }

    func toDosSubscription() {
        $toDos
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .encode(encoder: JSONEncoder())
            .tryMap {
                try $0.write(to: FileManager.docDirURL.appendingPathComponent(fileName))
            }
            .sink { [unowned self] in
                switch $0 {
                case .finished: print("Saving Completed")
                case .failure(let error):
                    if error is ToDoError {
                        appError = ErrorType(error: error as! ToDoError)
                    } else {
                        appError = ErrorType(error: .encodingError)
                    }
                }
            } receiveValue: { _ in
                print("Saving file was successful")
            }
            .store(in: &subscriptions)
    }
}
