import Combine
import Foundation

// MARK: - Chapter 3.2 - Error Handling

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

enum APIError: Error {
    case networkError(error: String)
    case responseError(error: String)
    case unknownError
}

let samplePost = Post(userId: 1, id: 2, title: "No Post", body: "")

// Create a `dataTaskPublisher`
let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
let publisher = URLSession.shared.dataTaskPublisher(for: url!)
    .map(\.data)
    .decode(type: [Post].self, decoder: JSONDecoder())

// Subscribe to the publisher with `mapError` Error handling
let cancellableSink = publisher
    .retry(2)
    .mapError { error -> Error in
        switch error {
        case URLError.cannotFindHost:
            return APIError.networkError(error: error.localizedDescription)
        default:
            return APIError.responseError(error: error.localizedDescription)
        }
    }
    .sink(receiveCompletion: { completion in
        print(String(describing: completion))
    }, receiveValue: { value in
        print("returned value \(value)")
    })


// A simple publisher example with `.tryMap` and `.catch`
Just(7)
    .tryMap { _ in
        throw APIError.unknownError
    }
    .catch { result in
        Just(2)
    }
    .sink { print($0) }


Just(5)
    .tryMap { _ in
        throw APIError.unknownError
    }
    .catch { result in
        Just(3)
    }
    .sink { print($0) }
