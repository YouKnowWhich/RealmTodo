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
    
    // 保存されるTodoItemをResults<TodoItem>として返す
    var items: Results<TodoItem> {
        realm.objects(TodoItem.self)
    }
    
    // TitleとDetailを受け取り、新規TodoItemを作成・登録する
    func addTodoItem(_ title: String, detail: String) {
        let item = TodoItem()
        item.id = UUID()
        item.title = title
        item.detail = detail
        try! realm.write {
            realm.add(item)
        }
    }
}

class TodoItem: Object, Identifiable {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var title: String
    @Persisted var detail: String
}
