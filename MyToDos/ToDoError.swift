import SwiftUI

enum ToDoError: Error, LocalizedError {
    case saveError
    case readError
    case decodingError
    case encodingError
    case emptyError

    var errorDescription: String? {
        switch self {
        case .emptyError: return NSLocalizedString("List empty", comment: "")
        case .saveError:
            return NSLocalizedString("Could not save ToDos, please reinstall the app.", comment: "")
        case .readError:
            return NSLocalizedString("Could not load ToDos, please reinstall the app.", comment: "")
        case .decodingError:
            return NSLocalizedString("There was a problem loading your ToDos, please create a new ToDo to start over.", comment: "")
        case .encodingError:
            return NSLocalizedString("Could not save ToDos, please reinstall the app.", comment: "")
        }
    }
}

struct ErrorType {
    let error: ToDoError
    var message: String {
        error.localizedDescription
    }
    let button = Button("OK", role: .cancel) {}
}
