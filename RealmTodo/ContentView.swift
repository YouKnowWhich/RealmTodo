// ViewのファイルRealmのデータを表示する
// Realmに保存されているTODOItemの数と、そのタイトルのリスト表示を行うビューを作る

import SwiftUI

struct ContentView: View {
    // NavigationViewの背景色を設定
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.91, green: 0.25, blue: 0.09, alpha: 1.00)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    // ViewModelは、EnvironmentObjectとして渡す
    @EnvironmentObject var viewModel: ViewModel
    let coordinator = Coordinator()
    
    var body: some View {
        NavigationView {
            List {
                // ViewModelがtodoItemsとしてResultsResults<TODOItem>を返すので、freezeして使う
                ForEach(viewModel.todoItems.freeze()) { item in
                    NavigationLink(destination: { coordinator.nextView(item) }, label: {
                        VStack(alignment: .leading) {
                            Text("\(item.title)")
                            Text("\(item.detail == "" ? "-" : item.detail)").font(.caption)
                        }
                    }).frame(maxWidth: .infinity)
                }
                // 削除処理
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        viewModel.removeTodoItem(viewModel.todoItems[index].id)
                    }
                }
            }
            .navigationTitle("TodoList")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        MyEditButton()  // MyEditButton
                        Text("#: \(viewModel.todoItems.count)")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
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
                        Image(systemName: "arrowshape.turn.up.left.circle")
                    })
                    .disabled(!viewModel.undoable)
                    
                    Button(action: {
                        viewModel.redo()
                    }, label: {
                        Image(systemName: "arrowshape.turn.up.right.circle")
                    })
                    .disabled(!viewModel.redoable)
                    
                    Spacer()
                }
            }
        }
    }
}

// MyEditButton
struct MyEditButton: View{
    @Environment(\.editMode) var editMode
    
    var body: some View {
        Button(action: {
            withAnimation() {
                if editMode?.wrappedValue.isEditing == true {
                    editMode?.wrappedValue = .inactive
                } else {
                    editMode?.wrappedValue = .active
                }
            }
        }) {
            if editMode?.wrappedValue.isEditing == true {
                Image(systemName: "checkmark.circle")
            } else {
                Image(systemName: "minus.circle")
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
