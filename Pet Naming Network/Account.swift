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
    var userPosts:[Pet];
    var bgColor:UIColor;
    init(userName:String,userPFP:UIImage,userPosts:[Pet]){
        self.userName = userName;
        self.userPFP = userPFP;
        self.userPosts = userPosts;
        bgColor = UIColor(displayP3Red: CGFloat(Int.random(in: 180...255)), green: CGFloat(Int.random(in: 180...255)), blue: CGFloat(Int.random(in: 180...255)), alpha: CGFloat(1))
    }
    init(userName:String,userPosts:[Pet]){
        self.userName = userName;
        self.userPFP = UIImage();
        self.userPosts = userPosts;
        let r:CGFloat = CGFloat.random(in: 0.7...1)
        let g:CGFloat = CGFloat.random(in: 0.7...1)
        let b:CGFloat = CGFloat.random(in: 0.7...1)
        bgColor = UIColor(displayP3Red: r, green: g, blue: b, alpha: CGFloat(1))
    }
    
}

class SmallUser:Codable{
    var id:Int
    var username:String
    var logged_in:Bool
}

class User:Codable{
    var id:Int
    var username:String
    var pets:[PetPost]
    var names:[String]
    var logged_in:Bool
}
