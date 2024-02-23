import Combine
import Foundation

// Chapter 3 - dataTaskPublisher

// MARK: - URL

// Create a `dataTaskPublisher`
let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
let publisher = URLSession.shared.dataTaskPublisher(for: url!)
    .map(\.data)
    .decode(type: [Post].self, decoder: JSONDecoder())

// Subscribe to the publisher

let cancellableSink = publisher.sink(receiveCompletion: { completion in
    print(String(describing: completion))
}, receiveValue: { value in
    print("returned value: \(value)")
})

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

let samplePost = Post(userId: 1, id: 11, title: "temporibus sit alias delectus eligendi possimus magni", body: "quo deleniti praesentium dicta non quod\naut est molestias\nmolestias et officia quis nihil\nitaque dolorem quia")

// MARK: - URLRequest
var request = URLRequest(url: url!)

let publisher2 = URLSession.shared.dataTaskPublisher(for: request)
    .map(\.data)
    .decode(type: Post.self, decoder: JSONDecoder())
