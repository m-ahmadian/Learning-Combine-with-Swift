import Combine
import Foundation

/*
 # Chapter 4.1 - Schedulers (Begin)
 
 Schedulers allow you to orchestrate where and when to publish, and knowing how to queue your upstream publishers, or downstream subscription streams, whether they should be processing in the background, in your main thread, sequence serially or concurrently. When using Combine to update your application's UI elements, it is crucial you optimize your streams to use main thread, but also not degrade the user experience.
 */

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

print("Publisher: On main thread?: \(Thread.current.isMainThread)")
print("Publisher: thread info: \(Thread.current)")

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
let queue = DispatchQueue(label: "a queue")

let publisher = URLSession.shared.dataTaskPublisher(for: url!)
    .map { $0.data }
    .decode(type: [Post].self, decoder: JSONDecoder())
//    .subscribe(on: queue)

let cancellableSink = publisher
//    .subscribe(on: queue)
    .receive(on: DispatchQueue.main)
//    .receive(on: DispatchQueue.global(qos: .background))
    .sink { completion in
        print("Publisher: On main thread?: \(Thread.current.isMainThread)")
        print("Publisher: thread info: \(Thread.current)")
    } receiveValue: { value in
        print("Publisher: On main thread?: \(Thread.current.isMainThread)")
        print("Publisher: thread info: \(Thread.current)")
    }

