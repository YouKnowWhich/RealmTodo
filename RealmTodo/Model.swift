// Realm を管理する。
// TodoModel ... TodoItemを管理 既存要素をコレクションとして提供する 新しい要素を Realm に追加する
// TodoItem  ... Title, Detail を受け取り新しいTODOItem(データモデル)を生成する

import Foundation
import RealmSwift

class TodoModel: ObservableObject {
    // Realmファイルの保存場所などの、Realmに対する設定をカスタマイズするオブジェクト
    var config: Realm.Configuration
    
    init() {
        config = Realm.Configuration()
    }
    
    var realm: Realm {
        return try! Realm(configuration: config)
    }
    
    // 保存されるTodoItemをResultsとして返す
    var items: Results {
        realm.objects(TodoItem.self)
    }
    
    // IDから要素を取得するメソッド
    func itemFromID(_ id: TodoItem.ID) -> TodoItem? {
        items.first(where: {$0.id == id})
    }
    
    // TODOModelに渡されたCommandを実行するメソッド
    func executeCommand(_ command: TodoModelCommand) {
        command.execute(self)
    }
    
}

class TodoItem: Object, Identifiable {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var title: String
    @Persisted var detail: String
}
