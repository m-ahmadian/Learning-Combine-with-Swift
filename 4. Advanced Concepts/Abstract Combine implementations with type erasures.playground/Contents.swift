/*:
 # Chapter 4.4 - Type Erasures (Begin)
 Combine also has an quivalent notion of implementation access, called Type
 Erasures. They let you design you Publishers so that you don't have to
 overexposed inner details of that publisher.
 */

import Combine
import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

var cancallables = Set<AnyCancellable>()

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
let publisher = URLSession.shared.dataTaskPublisher(for: url!)
    .map(\.data)
    .decode(type: Array<Post>.self, decoder: JSONDecoder())
    .eraseToAnyPublisher()

let cancellableSink: () = publisher
    .sink { completion in
        print(String(describing: completion))
    } receiveValue: { value in
        print("Returned value \(value)")
    }
    .store(in: &cancallables)
