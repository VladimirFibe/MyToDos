//
//  DataStore.swift
//  MyToDos
//
//  Created by Vladimir Fibe on 23.10.2023.
//

import SwiftUI

class DataStore: ObservableObject {
    @Published var toDos: [ToDo] = []
    
    init() {
        loadToDos()
    }
    func addToDo(_ toDo: ToDo) {
        toDos.append(toDo)
    }

    func updateToDo(_ toDo: ToDo) {
        guard let index = toDos.firstIndex(where: {$0.id == toDo.id}) else { return }
        toDos[index] = toDo
    }

    func deleteToDo(at indexSet: IndexSet) {
        toDos.remove(atOffsets: indexSet)
    }

    func loadToDos() {
        toDos = ToDo.sampleData
    }

    func saveToDos() {

    }
}
