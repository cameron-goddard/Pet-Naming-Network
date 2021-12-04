//
//  Account.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 11/20/21.
//

import Foundation
import UIKit



class Account{
    var userName:String;
    var userPFP:UIImage;
    var userPosts:[Pet] = [];
    var userNames:[Name] = []
    
    var bgColor:UIColor;
    init(user:User){
        self.userName = user.username
        self.userPFP = UIImage();
        
        for p in user.pets{
            self.userPosts.append(Pet(petPost: p,userName: userName))
        }
      
        for n in user.names{
            self.userNames.append(n)
        }

        let r:CGFloat = CGFloat.random(in: 0.7...1)
        let g:CGFloat = CGFloat.random(in: 0.7...1)
        let b:CGFloat = CGFloat.random(in: 0.7...1)
        bgColor = UIColor(displayP3Red: r, green: g, blue: b, alpha: CGFloat(1))
        self.userNames = []
    }
    
    
    func updateAccount(){
        NetworkManager.getAccountPets{pets in
            for p in pets{
                self.userPosts.append(Pet(petPost: p,userName: self.userName))
            }
        }
        
        NetworkManager.loginAccount(username: userName, completion: { user in
            print("WE SURPASSED!!!")
            print(self.userName)
            print(user.names)
            self.userNames = user.names
        })
        
    }
    
}

class SmallUser:Codable{
    var id:Int
    var username:String
    var loggedIn:Int
}

class User:Codable{
    internal init(id: Int, username: String, pets: [PetAccount], names: [Name], loggedIn: Int) {
        self.id = id
        self.username = username
        self.pets = pets
        self.names = names
        self.loggedIn = loggedIn
    }
    
    var id:Int
    var username:String
    var pets:[PetAccount]
    var names:[Name]
    var loggedIn:Int
}
