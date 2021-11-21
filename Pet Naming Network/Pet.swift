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
    
    public func addPetName(name:String){
        nameSuggestions.append(name);
    }
    
    public func petNames(nameSuggestions:[String]){
        self.nameSuggestions=nameSuggestions;
    }
   
}
class PetPost:Codable{
    let id:String;
    let state:String;
    let picture:String;
    let user:String;
    let names:[String];
    let date_created:String;

    init(id: String, state: String, picture: String, user: String, names: [String], date_created: String) {
        self.id = id
        self.state = state;
        self.picture = picture
        self.user = user
        self.names = names
        self.date_created = date_created
    }
}



enum State{
    case Naming
    case Voting
    case Featured
    
}
