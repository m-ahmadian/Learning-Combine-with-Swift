/*:
 # Chapter 4.3: Backpressure (Begin)
 Backpressure is a quite overlooked yet powerful control knob in the
 Publisher/Subscriber model, supported by the framework. I will spend a few minutes
 going through what backpressure in Combine is, and why you would want to make use of it.
 */

import Combine
import Foundation

let cityPublisher = (["San Jose", "San Francisco", "Menlo Park", "Palo Alto"]).publisher

final class CitySubscriber: Subscriber {
    typealias Input = String
    typealias Failure = Never
    
    func receive(subscription: any Subscription) {
        subscription.request(.max(3))
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        print("City: \(input)")
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Subscription: \(completion)")
    }
}

let citySubscription = CitySubscriber()
cityPublisher.subscribe(citySubscription)
