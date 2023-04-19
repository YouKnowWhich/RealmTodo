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
                // (2) ViewModelがtodoItemsとしてResults<TodoItem>を返すので、freezeして使う
                ForEach(viewModel.todoItems.freeze()) { item in
                    // (3) TODOItemのtitleプロパティをTextとして表示
                    Text("\(item.title)")
                }

            }
            .navigationTitle("Todoリスト")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // (4) NavigationBar の 左側に、現在の TODOItem の要素数を表示
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("残り: \(viewModel.todoItems.count)")
                }
                
                // (5) NavigationBar の右側には、要素追加用の + ボタンを配置します
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // 現在時刻を取得して、TODOItem のタイトル用文字列を作成
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
