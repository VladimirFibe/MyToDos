import Foundation


extension FileManager {
    static let fileName = "ToDos.json"

    func saveDocument(contents: String, docName: String = fileName) throws {
        let url = URL.documentsDirectory.appendingPathComponent(docName)
        do {
            try contents.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            throw ToDoError.saveError
        }
    }


    func readDocument(docName: String = fileName) throws -> Data {
        let url = URL.documentsDirectory.appendingPathComponent(docName)
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            throw ToDoError.readError
        }
    }

    func docExist(named docName: String = fileName) -> Bool {
        fileExists(atPath: URL.documentsDirectory.appendingPathComponent(docName).path)
    }
}

