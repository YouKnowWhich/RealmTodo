// CreateTODOItemCommandは、initializerでTitleと Detailを受け取り、executeメソッドで、受け取ったrealmに 指定値を持つようなTODOItemを作成する
// TodoModelで実行できるCommandは、protocol（TodoModelCommand）へ準拠させる

import Foundation

// protocolがAnyObjectに準拠することで、classへのみ適用できるprotocolとなる
protocol TodoModelCommand: AnyObject {
    func execute(_ model: TodoModel)
}

extension TodoModel {
    class CreateTodoItemCommand: TodoModelCommand {
        var title: String = ""
        var detail: String = ""
        
        init(title: String, detail: String = "") {
            self.title = title
            self.detail = detail
        }
        
        func execute(_ model: TodoModel) {
            let newItem = TodoItem()
            newItem.id = UUID()
            newItem.title = title
            newItem.detail = detail
            
            try! model.realm.write {
                model.realm.add(newItem)
            }
        }
    }
    
    // 指定したIDを持つTodoItemを削除する
    class RemoveTodoItemCommand: TodoModelCommand {
        var id: UUID
        
        
        init(id: TodoItem.ID) {
            self.id = id
        }
        
        func execute(_ model: TodoModel) {
            guard let itemToBeRemoved = model.itemFromID(self.id) else { return } // no item
            try! model.realm.write {
                model.realm.delete(itemToBeRemoved)
            }
        }
    }
}
