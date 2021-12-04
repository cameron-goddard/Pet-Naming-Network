//
//  Pet.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 11/18/21.
//

import Foundation
import UIKit


class Pet{
    
    var petName:Name;
    var nameSuggestions:[Name] = [];
    var user:String;
    var petImage:UIImage;
    var petState:State;
    var timeUploaded:String;
    var id:Int;

    init(petPost:PetPost){
        self.petName = Name();
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
            self.petName = Name(petID: petPost.id, pet: petPost.names[idx])
        }
        
        self.user = petPost.user.username
        let url = URL(string: petPost.pic)

        let data = try? Data(contentsOf: url!)
        self.petImage = UIImage(data: data! ) ?? UIImage()
        

        if(petPost.state.elementsEqual("State.FEATURED")){
            self.petState = .FEATURED
        }else if(petPost.state.elementsEqual("State.VOTING")){
            self.petState = .VOTING
        }else{
            self.petState = .NAMING
        }
        
        self.timeUploaded = petPost.dateCreated
        self.id = petPost.id
    }
    
    init(petPost:PetAccount,userName:String){

        var max:Int = 0;
        var idx:Int = 0;
        for x in 0..<petPost.names.count{
            if max < petPost.names[x].votes{
                max = petPost.names[x].votes
                idx = x;
            }
            nameSuggestions.append(Name(petID: petPost.id, pet: petPost.names[x]))
        }
        if(nameSuggestions.count > 0){
            nameSuggestions.remove(at: idx)
            self.petName = Name(petID: petPost.id, pet: petPost.names[idx])
        }else{
            self.petName = Name()
        }
        self.user = userName
        let url = URL(string: petPost.pic)

        let data = try? Data(contentsOf: url!)
        self.petImage = UIImage(data: data! ) ?? UIImage()
        if(petPost.state.elementsEqual("State.FEATURED")){
            self.petState = .FEATURED
        }else if(petPost.state.elementsEqual("State.VOTING")){
            self.petState = .VOTING
        }else{
            self.petState = .NAMING
        }
        self.timeUploaded = petPost.dateCreated
        self.id = petPost.id
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
    internal init() {
        self.id = 0
        self.name = ""
        self.pet = 0
        self.votes = 0
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


enum State:Codable{
    case NAMING
    case VOTING
    case FEATURED
}
