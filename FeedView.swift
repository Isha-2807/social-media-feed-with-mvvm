import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.feedItems) { item in
                    FeedItemView(item: item)
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: item)
                        }
                }
            }
            .refreshable {
                viewModel.refresh()
            }
            .navigationTitle("Feed")
        }
    }
}
