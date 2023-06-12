// 既存要素をコレクションとしてModelから受け取りViewに提供する
//　Viewからのリクエストで新しい要素を作成するようModelに依頼する

import Foundation
import SwiftUI
import RealmSwift

class ViewModel: ObservableObject {
    @Published var model: TodoModel = TodoModel()
    
    // Modelから受け取るResults<TodoItem>を(Viewへ)渡す
    var todoItems: Results<TodoItem> {
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
}

// MARK: TodoItem edit
extension ViewModel {
    
    // Viewからのリクエストで、Title, Detailに指定値を持つようにTodoItem作成を依頼
    func addTodoItem(_ title: String, detail: String = "") {
        let command = TodoModel.CreateTodoItemCommand(title, detail: detail)
        // 変更することを明示する
        objectWillChange.send()
        // Modelへ作成を依頼
        model.executeCommand(command)
    }
    
    func removeTodoItem(_ id: TodoItem.ID) {
        // RemoveTodoItemCommandを用意
        let command = TodoModel.RemoveTodoItemCommand(id)
        // Model が変更されることを通知
        objectWillChange.send()
        // Commandを実行
        model.executeCommand(command)
    }
    
    func updateTodoItemTitle(_ id: TodoItem.ID, newTitle: String) {
        let command = TodoModel.UpdateTodoItemProperty(id, keyPath: \TodoItem.title, newValue: newTitle)
        objectWillChange.send()
        model.executeCommand(command)
    }
    
    func updateTodoItemDetail(_ id:TodoItem.ID,newDetail: String) {
        let command = TodoModel.UpdateTodoItemProperty(id, keyPath: \TodoItem.detail, newValue: newDetail)
        objectWillChange.send()
        model.executeCommand(command)
    }
    
    // ViewModelからModelへの修正時に、MultipleCommandを使用するように変更
    func updateTodoItemTitleAndDetail(_ id: TodoItem.ID, newTitle: String?, newDetail: String?) {
        let command = TodoModel.MultipleCommand()
        if let newTitle = newTitle {
            command.add(TodoModel.UpdateTodoItemProperty(id, keyPath: \TodoItem.title, newValue: newTitle))
        }
        if let newDetail = newDetail {
            command.add(TodoModel.UpdateTodoItemProperty(id, keyPath: \TodoItem.detail, newValue: newDetail))
        }
        objectWillChange.send()
        model.executeCommand(command)
    }
}
