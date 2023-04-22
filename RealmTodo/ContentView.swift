// Viewのファイル Realmのデータを表示する
// Realmに保存されているTODOItemの数と そのタイトルのリスト表示を行うビューを作る

import SwiftUI

struct ContentView: View {
    // NavigationViewの背景色を設定
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.58, green: 0.69, blue: 0.75, alpha: 1.00)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    // (1) ViewModel は、EnvironmentObject として渡す
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.todoItems.freeze()) { item in
                    Text("\(item.title)")
                }
                // onDelete内で削除処理
                .onDelete{ indexSet in
                    if let index = indexSet.first {
                        // ViewModelには、removeTodoItemメソッドを作成予定
                        viewModel.removeTodoItem(viewModel.todoItems[index].id)
                    }
                }
            }
            .navigationTitle("Todoリスト")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        // Editボタンを表示
                        EditButton()
                        Text("残り: \(viewModel.todoItems.count)")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "YYYY/MM/dd(E) \nHH:mm:ss"
                        dateFormatter.locale = Locale(identifier: "ja_JP")
                        let itemName = dateFormatter.string(from: Date())
                        
                        viewModel.addTodoItem(itemName)
                    }){
                        Image(systemName: "plus")
                    }
                }
                // キーボードに閉じるボタンを配置
                ToolbarItem(placement: .keyboard){
                              Text("閉じる")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
