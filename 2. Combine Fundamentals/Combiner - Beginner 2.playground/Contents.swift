import Combine
import Foundation
import UIKit

// MARK: - (7) Just & Future

// Just: A simple publisher using Just, to produce once to each subscriber before termination
let _ = Just("a data stream")
    .sink { value in
        print("Value is \(value)")
    }

// Connect a subject to a publisher, and publish the value `29`
let subject = PassthroughSubject<Int, Never>()

Just(29)
    .subscribe(subject)

// A simple use of Future in a function
enum FutureError: Error {
    case notMultiple
}

let future = Future<String, FutureError> { promise in
    let calendar = Calendar.current
    let second = calendar.component(.second, from: Date())
    print("Second is \(second)")
    if second.isMultiple(of: 3) {
        promise(.success("We are successful: \(second)"))
    } else {
        promise(.failure(FutureError.notMultiple))
    }
}.catch { error in
    Just("Caught the error")
}
.delay(for: .init(1), scheduler: RunLoop.main)
.eraseToAnyPublisher()

future.sink(receiveCompletion: {
    print($0)
}, receiveValue: {
    print($0)
})

// MARK: - (8) Challenge

let textField = UITextField()

// Create a publisher, which publishes the following boolean array
let array = [true, false, false, false, false, true, true]
let publisher = array.publisher

// Create a subscriber, to assign to the textfield's isEnabled property, when publisher emits new data, from the publisher
let subscription = publisher.assign(to: \.isEnabled, on: textField)
textField.publisher(for: \.isEnabled).sink(receiveValue: {
    print($0)
})
// Add an operator, to drop the first 2 elements from the publisher, before the subscriber assigns to the button
let _ = publisher.dropFirst(2).sink { print($0) }

