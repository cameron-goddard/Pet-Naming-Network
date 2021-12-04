//
//  NetworkManager.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 12/2/21.
//

import Alamofire
import Foundation
import UIKit


class NetworkManager {
    
    
    /** Put the provided server endpoint here. If you don't know what this is, contact course staff. */
    static let host = "https://petnamingnetworkthree.herokuapp.com/"
    /*
     =======================================================================================
     ============================= Get Commands ============================================
     =======================================================================================
     */
    
    static func getPetNames(petID:Int,completion: @escaping([Name]) -> Void) {
        AF.request(host+"home/\(petID)/names/", method: .get).validate().responseData{response in
            switch response.result{
            case .success(let data):
                print(data)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let namesResponse = try? jsonDecoder.decode([Name].self, from: data) {
                    print(namesResponse);
                    completion(namesResponse);
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    static func getBestName(petID:Int,completion: @escaping(Name) -> Void) {
        AF.request(host+"home/\(petID)/popular/", method: .get).validate().responseData{response in
            switch response.result{
            case .success(let data):
                print(data)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let nameResponse = try? jsonDecoder.decode(Name.self, from: data) {
                    print(nameResponse);
                    completion(nameResponse);
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    static func getPetsNaming(completion: @escaping([PetPost]) -> Void) {
        AF.request(host+"home/naming/", method: .get).validate().responseData{response in
            switch response.result{
            case .success(let data):
                print(data)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let petResponse = try? jsonDecoder.decode([PetPost].self, from: data) {
                    print(petResponse);
                    completion(petResponse);
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    static func getPetsVoting(completion: @escaping([PetPost]) -> Void) {
        AF.request(host+"home/voting/", method: .get).validate().responseData{response in
            switch response.result{
            case .success(let data):
                print(data)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let petResponse = try? jsonDecoder.decode([PetPost].self, from: data) {
                    print(petResponse);
                    completion(petResponse);
                }
            case .failure(let error):
                print(error)
                completion([]);
            }
            
        }
    }
    
    static func getAccountNames(completion: @escaping([PetName]) -> Void) {
        AF.request(host+"home/account/names/", method: .get).validate().responseData{response in
            switch response.result{
            case .success(let data):
                print(data)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let nameResponse = try? jsonDecoder.decode([PetName].self, from: data) {
                    print(nameResponse);
                    completion(nameResponse);
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    static func getAccountPets(completion: @escaping([PetAccount]) -> Void) {
        AF.request(host+"home/account/Pets/", method: .get).validate().responseData{response in
            switch response.result{
            case .success(let data):

                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let petResponse = try? jsonDecoder.decode([PetAccount].self, from: data) {

                    completion(petResponse);
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
//    static func getFeaturedPets() {
//        AF.request(host+"home/", method: .get).validate().responseJSON{response in
//            switch response.result{
//            case .success(let data):
//                print(data)
//            case .failure(let error):
//                print("SADGE!!!");
//                print(error)
//            }
//        }
//    }
    static func getFeaturedPets(completion: @escaping([PetPost]) -> Void) {
        
        AF.request(host+"home/", method: .get).validate().responseData{response in
            switch response.result{
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let petResponse = try? jsonDecoder.decode([PetPost].self, from: data) {
                    completion(petResponse);
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    /*
     =======================================================================================
     ============================= Post Commands ============================================
     =======================================================================================
     */
    static func uploadImage(rawImage:String,completion: @escaping(PetPost) -> Void) {
        
        let parameters:[String:String]=[
            "image_data":rawImage
        ]
        AF.request(host+"home/uploading/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result{
            case .success(let data):
                print(data)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let petResponse = try? jsonDecoder.decode(PetPost.self, from: data) {
                    print(petResponse);
                    completion(petResponse);
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    static func giveName(name:String,petID:Int,completion: @escaping(Name) -> Void) {
        
        let parameters:[String:String]=[
            "name":name
        ]
        AF.request(host+"home/naming/\(petID)/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result{
            case .success(let data):
                print(data)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let nameResponse = try? jsonDecoder.decode(Name.self, from: data) {
                    print(nameResponse);
                    completion(nameResponse);
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    static func addVote(name:String,petID:Int,completion: @escaping(PetPost) -> Void) {
        
        let parameters:[String:String]=[
            "name":name
        ]
        AF.request(host+"home/voting/\(petID)/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result{
            case .success(let data):
                print(data)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let petResponse = try? jsonDecoder.decode(PetPost.self, from: data) {
                    print(petResponse);
                    completion(petResponse);
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    static func createAccount(username:String,completion: @escaping(User) -> Void) {
        
        let parameters:[String:String]=[
            "username":username
        ]
        AF.request(host+"home/account/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result{
            case .success(let data):
                print(data)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let userResponse = try? jsonDecoder.decode(User.self, from: data) {
                    print("YESSS!!!sodfjasuiodfhasudfhasdjfhjasdhfasdjlf")
                    print(userResponse);
                    completion(userResponse);
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    static func loginAccount(username:String,completion: @escaping(User) -> Void) {
        
        let parameters:[String:String]=[
            "username":username
        ]
        print(username)
        AF.request(host+"home/login/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result{
            case .success(let data):
          
                print(data)

                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let userResponse = try? jsonDecoder.decode(User.self, from: data) {
                    print("YEAH!")
                    print(userResponse);
                    completion(userResponse);
                }
            case .failure(let error):
                print(error)
                completion(User(id: 0, username: "", pets: [], names: [], loggedIn: 0));
            }
            
        }
    }
    
    
    
}
