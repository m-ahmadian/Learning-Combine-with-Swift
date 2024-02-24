import Combine
import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

let emptyPost = Post(userId: 0, id: 0, title: "Empty", body: "No results")

var cancellables = Set<AnyCancellable>()
let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
let publisher = URLSession.shared.dataTaskPublisher(for: url!)
    .map(\.data)
    .decode(type: [Post].self, decoder: JSONDecoder())
    .map { $0.first }
    .replaceNil(with: emptyPost)
    .compactMap { $0.title }
    


let cancellableSink = publisher
    .sink(receiveCompletion: { completion in
        print(String(describing: completion))
    }, receiveValue: { value in
        print("Returned value: \(value)")
    })
