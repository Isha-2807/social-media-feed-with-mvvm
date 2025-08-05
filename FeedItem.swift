import Foundation

enum FeedItemType: String, Codable {
    case text
    case image
    case video
    case plugin // for custom extensions
}

struct User: Identifiable, Codable {
    let id: UUID
    let username: String
    let profileImageURL: URL?
}

struct FeedItem: Identifiable, Codable {
    let id: UUID
    let type: FeedItemType
    let user: User
    let content: String?
    let mediaURL: URL?
    let timestamp: Date
}
