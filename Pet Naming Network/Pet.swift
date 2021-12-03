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
    var petState:State;
    //var timeUploaded:String;
    
    
    init(petName:String, user:String,petImageURL:String,petState:State){
        self.petName = petName;
        self.user = user;
        self.petImage = UIImage(named: petImageURL) ?? UIImage()
        self.petState = petState;
    }
    
    init(petName:String, user:String,petImage:UIImage,petState:State){
        self.petName = petName;
        self.user = user;
        self.petImage = petImage
        self.petState = petState;
    }
    
    public func addPetName(name:String){
        nameSuggestions.append(name);
    }
    
    public func petNames(nameSuggestions:[String]){
        self.nameSuggestions=nameSuggestions;
    }
   
}

class PetPost:Codable{
    
    internal init(title: String, pic: String,state:State, user: String, names: [String], id: Int) {
        self.title = title
        self.pic = pic
        self.state = state
        self.user = user
        self.names = names
        self.id = id
    }
    let title: String
    let pic:String
    let state:State;
    let user:String
    let names:[String];
    let id: Int

}



class PetsFeatured:Codable{
    let pets_featured:[PetPost];
}

class PetNameResponse:Codable{
    let names:[PetName];
}

class PetName:Codable{
    let id:Int;
    let name:String;
    let votes:String;
}


enum State:Codable{
    case NAMING
    case VOTING
    case FEATURED
}
