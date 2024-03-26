import Combine
import UIKit

let textField = UITextField()
let array = [true, false, false, false, true, true]

// A publisher that will emit the values of a Boolean array
let publisher = array.publisher

// A subscriber that will listen to the values and assign to a textfield's isEnabled property
let subscriber = publisher.assign(to: \.isEnabled, on: textField)
textField.publisher(for: \.isEnabled).sink { print($0) }

// An operator that will drop the first two elements before allowing the publisher to publish
let _ = publisher.dropFirst(2).sink { print($0) }

