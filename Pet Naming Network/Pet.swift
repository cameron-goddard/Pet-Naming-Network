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
    var nameSuggestions:[Name] = [];
    var user:String;
    var petImage:UIImage;
    var petState:String;
    var timeUploaded:String;
    var id:Int;

    init(petPost:PetPost){
        self.petName = "";
        var max:Int = 0;
        var idx:Int = 0;
        
        for x in 0..<petPost.names.count{
            if max < petPost.names[x].votes{
                max = petPost.names[x].votes
                idx = x;
            }
            nameSuggestions.append(Name(petID: petPost.id, pet: petPost.names[x]))
        }
        if(petPost.names.count>0){
            nameSuggestions.remove(at: idx)
            self.petName = petPost.names[idx].name
        }
        
        self.user = petPost.user.username
        let url = URL(string: petPost.pic)

        let data = try? Data(contentsOf: url!)
        self.petImage = UIImage(data: data! ) ?? UIImage()
        self.petState = petPost.state
        self.timeUploaded = petPost.dateCreated
        self.id = petPost.id
    }
    
    init(petPost:PetAccount,userName:String){
        self.petName = "";
        var max:Int = 0;
        var idx:Int = 0;
        print("========================================================")
        print(petPost.names);
        print(petPost.names.count);
        for x in 0..<petPost.names.count{
            if max < petPost.names[x].votes{
                max = petPost.names[x].votes
                idx = x;
            }
            nameSuggestions.append(Name(petID: petPost.id, pet: petPost.names[x]))
        }
        print("IDX: \(idx)");
        if(nameSuggestions.count > 0){
            nameSuggestions.remove(at: idx)
            self.petName = petPost.names[idx].name
        }else{
            self.petName = ""
        }
        self.user = userName
        let url = URL(string: petPost.pic)

        let data = try? Data(contentsOf: url!)
        self.petImage = UIImage(data: data! ) ?? UIImage()
        self.petState = petPost.state
        self.timeUploaded = petPost.dateCreated
        self.id = petPost.id
    }
    
    public func getPopularName(pet:PetPost){
        var max:Int = 0;
        var idx:Int = 0;
        for x in 0..<pet.names.count{
            if max < pet.names[x].votes{
                max = pet.names[x].votes
                idx = x;
            }
            nameSuggestions.append(Name(petID: pet.id, pet: pet.names[x]))
        }
        nameSuggestions.remove(at: idx)
        petName = pet.names[idx].name
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
    internal init(petID: Int, pet:PetName) {
        self.id = pet.id
        self.name = pet.name
        self.pet = petID
        self.votes = pet.votes
    }
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
