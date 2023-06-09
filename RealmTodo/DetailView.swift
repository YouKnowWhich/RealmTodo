// TodoItemのTitleとDetailを編集できるView

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    // TextFieldなどの要素のフォーカス制御を可能にする
    @FocusState var isActive: Bool
    
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
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isActive) // TextFieldのフォーカスをBool値で取得、操作
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button {
                                isActive = false
                            } label: {
                                Text(Image(systemName: "keyboard.chevron.compact.down"))
                                    .font(.system(size: 15))
                            }
                            
                        }
                    }
            }
            HStack {
                Text("Detail :").font(.caption).frame(width: 40)
                TextField("Detail", text: $detail)
                    .onAppear {
                        self.detail = item.detail
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isActive) // TextFieldのフォーカスをBool値で取得、操作
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
                    viewModel.updateTodoItemTitleAndDetail(item.id,
                                                           newTitle: title == item.title ? nil: title,
                                                           newDetail: detail == item.detail ? nil: detail)
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
