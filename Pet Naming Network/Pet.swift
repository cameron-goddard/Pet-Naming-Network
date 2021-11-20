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
   // var nameSuggestions:[String];
    var userUploaded:String;
    var petImage:UIImage;
    var petState:State;
    //var timeUploaded:String;
    
    
    init(petName:String, user:String,petImageURL:String,petState:State){
        self.petName = petName;
        self.userUploaded = user;
        self.petImage = UIImage(named: petImageURL) ?? UIImage()
        self.petState = petState;
    }
    
   
}
enum State{
    case naming
    case voting
    case featured
    
}
