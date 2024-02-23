import Foundation
import Combine
import UIKit
import SwiftUI

// MARK: - (1) A simple publisher using Just, to produce once for each subscriber
let _ = Just("Hello World")
    .sink { value in
        print("value is \(value)")
    }

// MARK: - (2) Taking advantage of NotificationCenter's publisher
let notification = Notification(name: .NSSystemClockDidChange, object: nil, userInfo: nil)
let notificationClockPublisher = NotificationCenter.default.publisher(for: .NSSystemClockDidChange)
    .sink { error in
        print("Error is \(error)")
    } receiveValue: { value in
        print("value is \(value)")
    }

NotificationCenter.default.post(notification)

// MARK: - (3) Create a new publisher operator, to square each value, using `map()`
[1, 5, 9]
    .publisher
    .map { $0 * $0 }
    .sink { print($0) }


// MARK: - (4) Use `decode()` with `map()` to convert a REST response to an object
let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

struct Task: Decodable {
    let id: Int
    let title: String
    let userId: Int
    let body: String
}

let dataPublisher = URLSession.shared.dataTaskPublisher(for: url)
//    .map { $0.data }
    .map(\.data)
    .decode(type: [Task].self, decoder: JSONDecoder())

let cancellableSink = dataPublisher
    .sink(receiveCompletion: { completion in
        print(completion)
    }, receiveValue: { items in
        print("Result \(items[0].title)")
    })

// MARK: - (5) Create a new Just publihser, map some text as prefix, and assign to label

[1, 5, 9]
    .publisher
    .sink { print($0) }


let label = UILabel()
Just("John")
    .map { "My name is \($0)" }
    .assign(to: \.text, on: label)


// MARK: - (6) Subjects

// Declare an Int PassthroughSubject
let subject = PassthroughSubject<Int, Never>()

// Attach a subscriber to the subject
let subscription = subject
    .sink { print($0) }

// Publish the value `94`, via the subject, directly
subject.send(94)

// Connect subject to a publisher, and publish the value `29`
Just(29)
    .subscribe(subject)

// Declare another subject, a CurrentValueSubject, with an initial `I am a ...` value cached
let anotherSubject = CurrentValueSubject<String, Never>("I am a ...")

// Attach a subscriber to the subject
let anotherSubscription = anotherSubject
    .sink { print($0) }

// Publish the value `Subject`, via the subject directly
anotherSubject.send("Subject")
