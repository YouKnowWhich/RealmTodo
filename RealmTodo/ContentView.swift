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
    
    @EnvironmentObject var viewModel: ViewModel
    let coordinator = Coordinator()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.todoItems.freeze()) { item in
                    NavigationLink(destination: { coordinator.nextView(item) }, label: {
                        VStack(alignment: .leading) {
                            Text("Title: \(item.title)")
                            Text("Detail: \(item.detail == "" ? "-" : item.detail)").font(.caption)
                        }
                    }).frame(maxWidth: .infinity)
                }
                // onDelete内で削除処理
                .onDelete { indexSet in
                    if let index = indexSet.first {
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
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "YYYY/MM/dd(E) \nHH:mm:ss"
                        dateFormatter.locale = Locale(identifier: "ja_JP")
                        let itemName = dateFormatter.string(from: Date())
                        viewModel.addTodoItem(itemName)
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        viewModel.undo()
                    }, label: {
                        Text("UNDO")
                    })
                    .disabled(!viewModel.undoable)
                    
                    Button(action: {
                        viewModel.redo()
                    }, label: {
                        Text("REDO")
                    })
                    .disabled(!viewModel.redoable)
                    Spacer()
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
