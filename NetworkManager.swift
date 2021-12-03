//
//  NetworkManager.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 12/2/21.
//

import Alamofire
import Foundation


class NetworkManager {
    
    /** To receive full marks on this assignment, you must do ALL of the following
        1) Setup CocoaPods to install and import Alamofire to actually do this assignment.
        2) Fill out the function stubs provided below - leave them untouched unless otherwise instructed.
            a) Note that all completions are of type `Any` - you should change these to the correct types (and any necessary keywords..)
        3) For each function stub, make sure you go to `Post.swift` to add Codable structs as necessary
        4) After filling in a function stub, go to `ViewController.swift` and add the completion in the marked area for that function and verify that your implementation works
            a) Steps are provided to help guide you in what to do inside your completion
            b) Print statements are provided to help you debug and to hint towards which variables you will need to use the implement the completion body
        5) Don't modify any other code in this project without good reason.
            a) This includes the MARK and explanatory comments, leave them to make your graders' lives easier.
     */
    
    /** Put the provided server endpoint here. If you don't know what this is, contact course staff. */
    static let host = "http://143.198.115.54:8080/posts/"
    
//    static func getAllPosts(completion: @escaping([Pet]) -> Void) {
//        AF.request(host, method: .get).validate().responseData{response in
//                switch response.result{
//                case .success(let data):
//                    print(data)
//                    let jsonDecoder = JSONDecoder()
//                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//                    if let petResponse = try? jsonDecoder.decode([Pet].self, from: data) {
//                            print(postResponse);
//                        completion(postResponse);
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//
//            }
//
//    }
    
    
}
