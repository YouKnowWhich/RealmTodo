// CreateTODOItemCommandは、initializerでTitleと Detailを受け取り、executeメソッドで、受け取ったrealmに 指定値を持つようなTODOItemを作成する
// TodoModelで実行できるCommandは、protocol（TodoModelCommand）へ準拠させる

import Foundation

// protocolがAnyObjectに準拠することで、classへのみ適用できるprotocolとなる
protocol TodoModelCommand: AnyObject {
    func execute(_ model: TodoModel)
    func undo(_ model: TodoModel)
}

extension TodoModel {
    class CreateTodoItemCommand: TodoModelCommand {
        var id: TodoItem.ID? = nil
        var title: String = ""
        var detail: String = ""
        
        init(title: String, detail: String = "") {
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
        
        init(id: TodoItem.ID) {
            self.id = id
        }
        
        func execute(_ model: TodoModel) {
            // save item info
            guard let itemToBeRemoved = model.itemFromID(self.id) else { return } // no item
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
}
