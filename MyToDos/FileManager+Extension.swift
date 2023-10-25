import Foundation

var fileName = "ToDos.json"

extension FileManager {

    static var docDirURL: URL {
        return Self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func saveDocument(contents: String, docName: String) throws {
        let url = URL.documentsDirectory.appendingPathComponent(docName)
        do {
            try contents.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            throw ToDoError.saveError
        }
    }


    func readDocument(docName: String) throws -> Data {
        let url = URL.documentsDirectory.appendingPathComponent(docName)
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            throw ToDoError.readError
        }
    }

    func docExist(named docName: String) -> Bool {
        fileExists(atPath: URL.documentsDirectory.appendingPathComponent(docName).path)
    }
}

