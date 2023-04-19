// 既存要素をコレクションとしてModel から受け取りViewに提供する
//　View からのリクエストで新しい要素を作成するよう Model に依頼する

import Foundation
import SwiftUI
import RealmSwift

class ViewModel: ObservableObject {
    @Published var model: TodoModel = TodoModel()
    
    // Modelから受け取るResuls<TodoItem>をViewへ渡す
    var todoItems: Results<TodoItem> {
        model.items
    }
    
    // Viewからのリクエストで、Title, Detailに指定された値でTodoItem作成をModelに依頼する
    func addTodoItem(_ title: String, detail: String = "") {
        // 変更することを明示する
        self.objectWillChange.send()
        // Model へ作成を依頼する
        model.addTodoItem(title, detail: detail)
    }
}
