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
            }
            
        }
    }
    
    static func getAccountPets(completion: @escaping([Name]) -> Void) {
        AF.request(host+"home/account/names/", method: .get).validate().responseData{response in
            switch response.result{
            case .success(let data):
                print(data)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let nameResponse = try? jsonDecoder.decode([Name].self, from: data) {
                    print(nameResponse);
                    completion(nameResponse);
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    static func getFeaturedPets(completion: @escaping([PetPost]) -> Void) {
        AF.request(host+"home/", method: .get).validate().responseData{response in
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
    /*
     =======================================================================================
     ============================= Post Commands ============================================
     =======================================================================================
     */
    static func uploadImage(rawImage:UIImage,completion: @escaping(PetPost) -> Void) {
        
        let imageData = rawImage.pngData()
        let imageBase64String:String? = imageData?.base64EncodedString()
        
        let parameters:[String:String]=[
            "image_data":imageBase64String ?? ""
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
            "name":username
        ]
        AF.request(host+"home/account/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result{
            case .success(let data):
                print(data)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let userResponse = try? jsonDecoder.decode(User.self, from: data) {
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
            "name":username
        ]
        AF.request(host+"home/account/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData {
            response in
            switch response.result{
            case .success(let data):
                print(data)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let userResponse = try? jsonDecoder.decode(User.self, from: data) {
                    print(userResponse);
                    completion(userResponse);
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    
    
}
