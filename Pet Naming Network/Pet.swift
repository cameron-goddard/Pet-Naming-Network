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
        nameSuggestions = ["dummy1","dummy2","dummy3","dummy4","dummy5"]
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
    let id:Int;
    let state:State;
    let pic:String;
    let user:SmallUser;
    let names:[PetName]
    let date_created:String
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


enum State:Codable{
    case NAMING
    case VOTING
    case FEATURED
}
