import SwiftUI

struct ContentView: View {
    // 背景色を設定
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.58, green: 0.69, blue: 0.75, alpha: 1.00)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            List {
                Text("マイク")
                Text("ダスティン")
                Text("ルーカス")
            }
            .navigationTitle("Todoリスト")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("左のボタン")
                    }) {
                        Image(systemName: "ellipsis.circle")
                        
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("右のボタン")
                    }){
                        Image(systemName: "gearshape")
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
    }
}
