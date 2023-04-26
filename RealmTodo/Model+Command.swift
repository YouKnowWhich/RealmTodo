// CreateTODOItemCommandは、initializerでTitleと Detailを受け取り、executeメソッドで、受け取ったrealmに 指定値を持つようなTODOItemを作成する
// TodoModelで実行できるCommandは、protocol（TodoModelCommand）へ準拠させる

import Foundation

// protocolがAnyObjectに準拠することで、classへのみ適用できるprotocolとなる
protocol TodoModelCommand: AnyObject {
    func execute(_ model: TodoModel)
    func undo(_ model: TodoModel)
}

// TODOModelCommandに準拠しつつ、内部に複数のTODOModelCommandを持ち、順番に実行するコマンド
extension TodoModel {
    class MultipleCommand: TodoModelCommand {
        var commands: [TodoModelCommand] = []
        func add(_ command: TodoModelCommand) {
            commands.append(command)
        }
        
        // executeの際には保持している順番に実行
        func execute(_ model: TodoModel) {
            for command in commands {
                command.execute(model)
            }
        }
        
        // UNDOの際には、逆順に実行
        func undo(_ model: TodoModel) {
            for command in commands.reversed() {
                command.undo(model)
            }
        }
    }
}

extension TodoModel {
    class CreateTodoItemCommand: TodoModelCommand {
        var id: TodoItem.ID? = nil
        var title: String = ""
        var detail: String = ""
        
        init(_ title: String, detail: String = "") {
            self.title = title
            self.detail = detail
        }
        
        func execute(_ model: TodoModel) {
            let newItem = TodoItem()
            newItem.id = self.id ?? UUID()
            newItem.title = title
            newItem.detail = detail
            
            try! model.realm.write {
                model.realm.add(newItem)
            }
            id = newItem.id
        }
        func undo(_ model: TodoModel) {
            guard let id = self.id,
                  let item = model.itemFromID(id) else { return }
            try! model.realm.write {
                model.realm.delete(item)
            }
        }
    }
    
    
    class RemoveTodoItemCommand: TodoModelCommand {
        var id: UUID
        var title: String? = nil
        var detail: String? = nil
        
        init(_ id: TodoItem.ID) {
            self.id = id
        }
        
        func execute(_ model: TodoModel) {
            // save item info
            guard let itemToBeRemoved = model.itemFromID(self.id) else { return }
            self.title = itemToBeRemoved.title
            self.detail = itemToBeRemoved.detail
            try! model.realm.write {
                model.realm.delete(itemToBeRemoved)
            }
        }
        
        func undo(_ model: TodoModel) {
            guard let title = self.title,
                  let detail = self.detail else { return }
            let item = TodoItem()
            item.id = self.id
            item.title = title
            item.detail = detail
            try! model.realm.write {
                model.realm.add(item)
                self.title = nil
                self.detail = nil
            }
        }
    }
    // GenericsとKeyPathを使用し、TODOItemのtitleを更新するコマンド
    class UpdateTodoItemProperty<T>: TodoModelCommand {
        let id: TodoItem.ID
        let keyPath: ReferenceWritableKeyPath<TodoItem, T>
        let newValue: T
        var oldValue: T?
        
        init(_ id: TodoItem.ID, keyPath: ReferenceWritableKeyPath<TodoItem, T>, newValue: T) {
            self.id = id
            self.keyPath = keyPath
            self.newValue = newValue
            self.oldValue = nil
        }
        
        func execute(_ model: TodoModel) {
            guard let item = model.itemFromID(id) else { return }
            try! model.realm.write {
                self.oldValue = item[keyPath: keyPath]
                item[keyPath: keyPath] = newValue
            }
        }
        
        func undo(_ model: TodoModel) {
            guard let item = model.itemFromID(id) else { return }
            guard let oldValue = oldValue else { return }
            try!model.realm.write {
                item[keyPath: keyPath] = oldValue
            }
        }
    }
    
    // KeyPathとGenericsを使用した、プロパティを更新するための汎用的なコマンド
    class UpdateTodoItemString: TodoModelCommand {
        let id: TodoItem.ID
        let keyPath: ReferenceWritableKeyPath<TodoItem, String>
        let newValue: String
        var oldValue: String?
        
        init(id: TodoItem.ID, keyPath: ReferenceWritableKeyPath<TodoItem, String>, newValue: String) {
            self.id = id
            self.keyPath = keyPath
            self.newValue = newValue
            self.oldValue = nil
        }
        
        func execute(_ model: TodoModel) {
            guard let item = model.itemFromID(id) else { return }
            try! model.realm.write {
                self.oldValue = item[keyPath: keyPath]
                item[keyPath: keyPath] = newValue
            }
        }
        
        func undo(_ model: TodoModel) {
            guard let item = model.itemFromID(id) else { return }
            guard let oldValue = oldValue else { return }
            try! model.realm.write {
                item[keyPath: keyPath] = oldValue
            }
        }
    }
    
    class UpdateTodoItemTitle: TodoModelCommand {
        let id: TodoItem.ID
        let newTitle: String
        var oldTitle: String?
        
        init(_ id: TodoItem.ID, newTitle: String) {
            self.id = id
            self.newTitle = newTitle
            self.oldTitle = nil
        }
        
        func execute(_ model: TodoModel) {
            guard let item = model.itemFromID(id) else { return }
            try! model.realm.write {
                self.oldTitle = item.title
                item.title = newTitle
            }
        }
        
        func undo(_ model: TodoModel) {
            guard let item = model.itemFromID(id) else { return }
            guard let oldTitle = oldTitle else { return }
            try! model.realm.write {
                item.title = oldTitle
            }
        }
    }
}
