import Foundation
import Combine

final class FeedViewModel: ObservableObject {
    @Published var feedItems: [FeedItem] = []
    @Published var isLoading = false
    @Published var isRefreshing = false

    private var offset = 0
    private let pageSize = 10
    private let service: FeedServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(service: FeedServiceProtocol = MockFeedService()) {
        self.service = service
        loadInitialFeed()
    }

    func loadInitialFeed() {
        isLoading = true
        service.fetchFeedItems(offset: 0, limit: pageSize)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            }, receiveValue: { [weak self] items in
                self?.feedItems = items
                self?.offset = items.count
            })
            .store(in: &cancellables)
    }

    func refresh() {
        isRefreshing = true
        service.refreshFeed()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.isRefreshing = false
            }, receiveValue: { [weak self] items in
                self?.feedItems = items
                self?.offset = items.count
            })
            .store(in: &cancellables)
    }

    func loadMoreIfNeeded(currentItem item: FeedItem?) {
        guard let item = item else { return }
        let thresholdIndex = feedItems.index(feedItems.endIndex, offsetBy: -3)
        if feedItems.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMore()
        }
    }

    private func loadMore() {
        guard !isLoading else { return }
        isLoading = true
        service.fetchFeedItems(offset: offset, limit: pageSize)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            }, receiveValue: { [weak self] newItems in
                self?.feedItems.append(contentsOf: newItems)
                self?.offset += newItems.count
            })
            .store(in: &cancellables)
    }
}
