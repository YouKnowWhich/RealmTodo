// 既存要素をコレクションとしてModel から受け取りViewに提供する
//　View からのリクエストで新しい要素を作成するよう Model に依頼する

import Foundation
import SwiftUI
import RealmSwift

class ViewModel: ObservableObject {
    @Published var model: TodoModel = TodoModel()
    
    // Modelから受け取るResulsをViewへ渡す
    var todoItems: Results {
        model.items
    }
    
    // Viewからのリクエストで、Title, Detailに指定された値でTodoItem作成をModelに依頼する
    func addTodoItem(_ title: String, detail: String = "") {
        let command = TodoModel.CreateTodoItemCommand(title, detail: detail)
        objectWillChange.send()
        model.executeCommand(command)
    }
    
    func removeTodoItem(_ id: TodoItem.ID) {
        // (1) RemoveTodoItemCommandを用意
        let command = TodoModel.RemoveTodoItemCommand(id)
        // (2) Modelが変更されることを通知
        objectWillChange.send()
        // (3) Commandを実行
        model.executeCommand(command)
    }
}
