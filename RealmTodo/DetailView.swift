// TodoItemのTitleとDetailを編集できるView

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    // 一時的に入力値を保存するために @State 定義の変数を用意
    let item: TodoItem
    @State private var title = ""
    @State private var detail = ""
    
    var body: some View {
        List {
            HStack {
                Text("Title :").font(.caption).frame(width: 40)
                TextField("Title", text: $title)
                    .onAppear {
                        self.title = item.title
                    }
                    .textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("Detail :").font(.caption).frame(width: 40)
                TextField("Detail", text: $detail)
                    .onAppear {
                        self.detail = item.detail
                    }
                    .textFieldStyle(.roundedBorder)
            }
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }, label: {
                    Text("cancel").font(.title)
                })
                .buttonStyle(.borderless)
                Spacer()
                // 入力された値を使ってViewModelに変更依頼
                Button(action: {
                    if title != item.title {
                        viewModel.updateTodoItemTitle(item.id, newTitle: title)
                    }
                    if detail != item.detail {
                        viewModel.updateTodoItemDetail(item.id, newDetail: detail)
                    }
                    dismiss()
                }, label: {
                    Text("update").font(.title)
                })
                .buttonStyle(.borderless)
                Spacer()
            }
        }
        // ナビゲーションバーの戻るボタンは非表示
        .navigationBarBackButtonHidden(true)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(item: TodoItem.previewItem())
            .environmentObject(ViewModel())
    }
}
