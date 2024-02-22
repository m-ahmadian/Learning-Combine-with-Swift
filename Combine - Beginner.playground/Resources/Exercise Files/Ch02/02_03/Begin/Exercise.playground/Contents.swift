/*:
# Chapter 2.3 - Operators (Begin)
Apple provide you with pre-built functions that extend your Publishers, helping you refine your logic, and these are called **Operators**.
*/


import Foundation
import Combine


//(1) Create a new publisher operator, to square each value, using `map()`


//(2) Use `decode()` with `map()` to convert a REST respones to an object
let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

struct Task: Decodable {
    let id: Int
    let title: String
    let userId: Int
    let body: String
}
