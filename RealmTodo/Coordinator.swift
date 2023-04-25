// ビュー間の依存関係を低減
// 適切なビューを選択するという責務をContentViewから切り離し、新たなCoordinatorクラスを使って選択する

import Foundation
import SwiftUI

class Coordinator: ObservableObject {
    @ViewBuilder
    func nextView(_ item: TodoItem) -> some View {
        DetailView(item: item)
    }
}
