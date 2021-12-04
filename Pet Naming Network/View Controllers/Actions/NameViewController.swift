//
//  NameViewController.swift
//  Pet Naming Network
//
//  Created by Cameron Goddard on 12/2/21.
//

import UIKit

class NameViewController: UIViewController {

    private var imageView = UIImageView()
    private var nameTextField = UITextField()
    private var submitButton = UIButton()
    private var skipButton = UIButton()
    private var index:Int = -1;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Pet(petPost: LoginViewController.petServer.petsNaming[0]).petImage
       
        view.addSubview(imageView)
        
        nameTextField.textColor = .label
        nameTextField.font = .systemFont(ofSize: 14)
        nameTextField.borderStyle = .roundedRect
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.backgroundColor = .secondarySystemFill
        nameTextField.placeholder = "Enter your name for this image"
        nameTextField.addTarget(self, action: #selector(resignFirstResponder), for: .editingDidEndOnExit)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        submitButton.configuration = .filled()
        submitButton.configuration?.buttonSize = .large
        submitButton.setTitle("Submit Name", for: .normal)
        submitButton.addTarget(self, action: #selector(submitName), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
        
        skipButton.configuration = .filled()
        skipButton.configuration?.buttonSize = .large
        skipButton.setTitle("Skip Name", for: .normal)
        skipButton.addTarget(self, action: #selector(skipName), for: .touchUpInside)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(skipButton)
        
        setUpConstraints()
    }
//    func addData(){
//        if(petServer.petsNaming.count == 0){
//            self.imageView.image = UIImage(systemName: "bolt.ring.closed")
//        }else {
//            self.imageView.image = Pet(petPost: petServer.petsNaming[0]).petImage
//        }
//    }
    
    
    @objc func submitName() {
        let name:String = nameTextField.text ?? ""
        if(!name.elementsEqual("")){
            let pet = Pet(petPost: LoginViewController.petServer.petsNaming[index])
            NetworkManager.giveName(name: name, petID: pet.id, completion: {name in
                self.nextImage()
                PetServer.account.updateAccount()
            })
            
        }
    }
    
    @objc func skipName() {
        nextImage()
    }
    
    func nextImage() {
        nameTextField.text = ""
        
        index = index + 1;
        if(index >= LoginViewController.petServer.petsNaming.count){
            index = 0;
        }
        if(LoginViewController.petServer.petsNaming.count == 0){
            UIView.transition(with: imageView, duration: 1.0, options: .transitionFlipFromLeft, animations: {
                self.imageView.image = UIImage(systemName: "bolt.ring.closed")
            
            }, completion: nil)
        }else{
            let pet = Pet(petPost: LoginViewController.petServer.petsNaming[index])
            
            UIView.transition(with: imageView, duration: 1.0, options: .transitionFlipFromLeft, animations: {
                self.imageView.image = pet.petImage
            }, completion: nil)
        }
      
    }
    
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width-40),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: view.frame.width-40)
        ])
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: view.frame.width-40)
        ])
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: view.frame.width-40)
        ])
        
    }
}
