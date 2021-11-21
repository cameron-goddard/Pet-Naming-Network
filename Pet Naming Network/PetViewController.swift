//
//  PetViewController.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 11/21/21.
//

import UIKit
import SnapKit

class PetViewController: UIViewController {

    private var petImageView:UIImageView = UIImageView();
    private var petNameLabel:UILabel = UILabel();
    private var userNameLabel:UILabel = UILabel();
  
    private var pet:Pet
    init(pet:Pet){
        self.pet = pet;
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pet"
        view.backgroundColor = .white;
        
        petImageView.contentMode = .scaleAspectFit
        
        petImageView.image = pet.petImage;
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(petImageView)
        
        petNameLabel.text = pet.petName
        petNameLabel.textAlignment = .center
        petNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        petNameLabel.textColor = .orange
        petNameLabel.translatesAutoresizingMaskIntoConstraints = false;
 
        view.addSubview(petNameLabel)
        
        userNameLabel.text = pet.user
        
        userNameLabel.textAlignment = .center
        userNameLabel.font = .systemFont(ofSize: 16)
        userNameLabel.textColor = .black
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        view.addSubview(userNameLabel);
        
        setupConstraints()
    }
    
    
    
    func setupConstraints(){
        let padding:CGFloat = 8;
        let imagePadding:CGFloat = 40;
        let width:CGFloat = view.frame.width-imagePadding*4;
        
        NSLayoutConstraint.activate([
            petImageView.topAnchor.constraint(equalTo: view.topAnchor,constant: imagePadding),
            petImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            petImageView.heightAnchor.constraint(equalToConstant: width),
            petImageView.widthAnchor.constraint(equalToConstant: width),
            petImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:imagePadding),
            petImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:-imagePadding),
        ])
        NSLayoutConstraint.activate([
            petNameLabel.topAnchor.constraint(equalTo: petImageView.bottomAnchor,constant: padding),
            petNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            petNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
            petNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
        ])
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: petNameLabel.bottomAnchor,constant: padding),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
        ])
    }
    
}
