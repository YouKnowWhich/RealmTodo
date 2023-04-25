// 既存要素をコレクションとしてModel から受け取りViewに提供する
//　View からのリクエストで新しい要素を作成するよう Model に依頼する

import Foundation
import SwiftUI
import RealmSwift

class ViewModel: ObservableObject {
    @Published var model: TodoModel = TodoModel()
    
    var todoItems: Results {
        model.items
    }
    
    func undo() {
        guard undoable else { return }
        objectWillChange.send()
        model.undo()
    }
    
    func redo() {
        guard redoable else { return }
        objectWillChange.send()
        model.redo()
    }
    
    var undoable: Bool {
        return model.undoable
    }
    
    var redoable: Bool {
        return model.redoable
    }
    
    func addTodoItem(_ title: String, detail: String = "") {
        let command = TodoModel.CreateTodoItemCommand(title, detail: detail)
        objectWillChange.send()
        model.executeCommand(command)
    }
    
    func removeTodoItem(_ id: TodoItem.ID) {
        let command = TodoModel.RemoveTodoItemCommand(id)
        objectWillChange.send()
        model.executeCommand(command)
    }
}
