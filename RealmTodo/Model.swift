// Realm を管理する。
// TodoModel ... TodoItemを管理 既存要素をコレクションとして提供する 新しい要素をRealmに追加する
// TodoItem  ... Title, Detailを受け取り新しいTODOItem(データモデル)を生成する

import Foundation
import RealmSwift

// TodoItemを管理するクラスTODOModelを定義 このModelを経由して、Realmにアクセスする
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

    // 保存されているTodoItemすべて Results<TodoItem>として渡すメソッド(items)を用意
    var items: Results<TodoItem> {
        realm.objects(TodoItem.self)
    }
    
    // TodoModelに、IDから要素を取得するメソッドを追加
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

// タイトルと詳細をStringで持ち、UUID型のidを持つ要素TodoItemとして定義
class TodoItem: Object, Identifiable {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var title: String
    @Persisted var detail: String
}

extension TodoItem {
    static func previewItem() -> TodoItem {
        let item = TodoItem()
        item.id = UUID()
        item.title = "Title"
        item.detail = "Detail"
        return item
    }
}
