// Realm を管理する。
// TodoModel ... TodoItemを管理 既存要素をコレクションとして提供する 新しい要素を Realm に追加する
// TodoItem  ... Title, Detail を受け取り新しいTODOItem(データモデル)を生成する

import Foundation
import RealmSwift

class TodoModel: ObservableObject {
    var config: Realm.Configuration
    var undoStack: [TodoModelCommand] = []
    var redoStack: [TodoModelCommand] = []
    
    init() {
        config = Realm.Configuration()
    }
    
    var realm: Realm {
        return try! Realm(configuration: config)
    }

    var items: Results {
        realm.objects(TodoItem.self)
    }
    
    func itemFromID(_ id: TodoItem.ID) -> TodoItem? {
        items.first(where: {$0.id == id})
    }
    
    func executeCommand(_ command: TodoModelCommand) {
        redoStack = []
        command.execute(self)
        undoStack.append(command)
    }
    
    var undoable: Bool {
        return !undoStack.isEmpty
    }
    
    var redoable: Bool {
        return !redoStack.isEmpty
    }
    
    func undo() {
        guard let undoCommand = undoStack.popLast() else { return }
        undoCommand.undo(self)
        redoStack.append(undoCommand)
    }
    
    func redo() {
        guard let redoCommand = redoStack.popLast() else { return }
        redoCommand.execute(self)
        undoStack.append(redoCommand)
    }
}

class TodoItem: Object, Identifiable {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var title: String
    @Persisted var detail: String
}
