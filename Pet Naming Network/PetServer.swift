//
//  PetServer.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 12/4/21.
//

import Foundation


class PetServer{
    
    public static var account:Account!;
    
    var petsNaming:[PetPost] = []
    var petsVoting:[PetPost] = []
    
    
    
    
    func updateServer(){
        NetworkManager.getPetsNaming{ pets in
            self.petsNaming = pets;
        }
        
        NetworkManager.getPetsVoting{ pets in
            self.petsVoting = pets;
        }
    }
    
}
