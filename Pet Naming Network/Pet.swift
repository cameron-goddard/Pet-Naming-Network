//
//  Pet.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 11/18/21.
//

import Foundation
import UIKit


class Pet{
    
    var petName:String;
    var nameSuggestions:[String] = [];
    var user:String;
    var petImage:UIImage;
    var petState:String;
    var timeUploaded:String;
    
    
    init(petName:String, user:String,petImageURL:String,petState:String){
        self.petName = petName;
        self.user = user;
        self.petImage = UIImage(named: petImageURL) ?? UIImage()
        self.petState = petState;
        nameSuggestions = ["dummy1","dummy2","dummy3","dummy4","dummy5"]
        self.timeUploaded = "NEVER!!"
    }
    
    init(petName:String, user:String,petImage:UIImage,petState:String){
        self.petName = petName;
        self.user = user;
        self.petImage = petImage
        self.petState = petState;
        self.timeUploaded = "NEVER!!"
    }
    
    init(petPost:PetPost){
        self.petName = "";
        var max:Int = 0;
        var idx:Int = 0;
        
        for x in 0..<petPost.names.count{
            if max < petPost.names[x].votes{
                max = petPost.names[x].votes
                idx = x;
            }
            nameSuggestions.append(petPost.names[x].name)
        }
        nameSuggestions.remove(at: idx)
        self.petName = petPost.names[idx].name
        
        self.user = petPost.user.username
        let url = URL(string: petPost.pic)
        print("===============Pet==============================")
        print(petPost.pic)
        print(url)
        let data = try? Data(contentsOf: url!)
        self.petImage = UIImage(data: data! ) ?? UIImage()
        self.petState = petPost.state
        self.timeUploaded = petPost.dateCreated
        
    }
    
    public func getPopularName(pet:PetPost){
        var max:Int = 0;
        var idx:Int = 0;
        for x in 0..<pet.names.count{
            if max < pet.names[x].votes{
                max = pet.names[x].votes
                idx = x;
            }
            nameSuggestions.append(pet.names[x].name)
        }
        nameSuggestions.remove(at: idx)
        petName = pet.names[idx].name
    }
    
    public func addPetName(name:String){
        nameSuggestions.append(name);
    }
    
    public func petNames(nameSuggestions:[String]){
        self.nameSuggestions=nameSuggestions;
    }
   
}

class PetAccount:Codable{
    let id:Int;
    let dateCreated:String
    let names:[PetName]
    let pic:String;
    let state:String;
}
class PetPost:Codable{
    let id:Int;
    let dateCreated:String
    let names:[PetName]
    let pic:String;
    let state:String;
    let user:SmallUser;
}

class Name:Codable{
    
    let id:Int
    let name:String
    let pet:Int
    let votes:Int
}


class PetName:Codable{
    let id:Int;
    let name:String;
    let votes:Int;
}


//enum State:Codable{
//    case NAMING
//    case VOTING
//    case FEATURED
//}
