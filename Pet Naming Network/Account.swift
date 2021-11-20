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
    
    init(userName:String,userPFP:UIImage,userPosts:[Pet]){
        self.userName = userName;
        self.userPFP = userPFP;
        self.userPosts = userPosts;
    }
    
}
