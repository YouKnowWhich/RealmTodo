// ViewModelをEnvironmentObjectとして使用するために、Appで以下のようにViewModelをEnvironmentObjectとして指定

import SwiftUI

@main
struct RealmTodoApp: App {
    @StateObject var viewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
