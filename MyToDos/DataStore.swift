//
//  DataStore.swift
//  MyToDos
//
//  Created by Vladimir Fibe on 23.10.2023.
//

import SwiftUI

class DataStore: ObservableObject {
    @Published var toDos: [ToDo] = []
    @Published var appError: ErrorType? = nil
    init() {
        print(FileManager.docDirURL.path)
        if FileManager().docExist(named: fileName) {
            loadToDos()
        }
    }
    func addToDo(_ toDo: ToDo) {
        toDos.append(toDo)
        saveToDos()
    }

    func updateToDo(_ toDo: ToDo) {
        guard let index = toDos.firstIndex(where: {$0.id == toDo.id}) else { return }
        toDos[index] = toDo
        saveToDos()
    }

    func deleteToDo(at indexSet: IndexSet) {
        toDos.remove(atOffsets: indexSet)
        saveToDos()
    }

    func loadToDos() {
        FileManager().readDocument(docName: fileName) { (result) in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    toDos = try decoder.decode([ToDo].self, from: data)
                } catch {
                    print(ToDoError.decodingError.localizedDescription)
                    appError = ErrorType(error: .decodingError)
                    //                    showErrorAlert = true
                }
            case .failure(let error):
                print(error.localizedDescription)
                appError = ErrorType(error: error)
                //                showErrorAlert = true
            }
        }
    }

    func saveToDos() {
        print("Saving toDos to file system")
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(toDos)
            let jsonString = String(decoding: data, as: UTF8.self)
            FileManager().saveDocument(contents: jsonString, docName: fileName) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    appError = ErrorType(error: error)
                    //                    showErrorAlert = true
                }
            }
        } catch {
            print(ToDoError.encodingError.localizedDescription)
            appError = ErrorType(error: .encodingError)
            //            showErrorAlert = true
        }
    }
}
