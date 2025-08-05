import Foundation
import Combine

protocol FeedServiceProtocol {
    func fetchFeedItems(offset: Int, limit: Int) -> AnyPublisher<[FeedItem], Error>
    func refreshFeed() -> AnyPublisher<[FeedItem], Error>
}

class MockFeedService: FeedServiceProtocol {
    func fetchFeedItems(offset: Int, limit: Int) -> AnyPublisher<[FeedItem], Error> {
        let user = User(id: UUID(), username: "john_doe", profileImageURL: nil)
        let items = (0..<limit).map { i in
            FeedItem(
                id: UUID(),
                type: FeedItemType.allCases.randomElement() ?? .text,
                user: user,
                content: "Post #\(offset + i)",
                mediaURL: nil,
                timestamp: Date()
            )
        }
        return Just(items)
            .delay(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func refreshFeed() -> AnyPublisher<[FeedItem], Error> {
        fetchFeedItems(offset: 0, limit: 10)
    }
}

extension FeedItemType: CaseIterable {}
