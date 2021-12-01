//
//  LoginViewController.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 11/30/21.
//

import UIKit

class LoginViewController: UIViewController {

    //private var imagePicker: ImagePicker!
    
    private var userName:String = "Bob123"
    private var account:Account = Account(userName: "", userPosts: [])
    private var petsShown:[Pet] = []
    private var appTitleLabel:UILabel = {
        let label = UILabel();
        label.text = "Pet Naming Network"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }()
    private var userNameTextField:UITextField = {
        let textField = UITextField();
        textField.text = nil
        textField.placeholder = "Username"
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 14)
        textField.layer.backgroundColor = UIColor.systemGray6.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false;
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 20;
      
        return textField;
    }()
    
    private let loginButton:UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 52));
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.systemBlue.cgColor;
        button.layer.borderWidth = 1;
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitleColor(.black, for: .normal)
        return button;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        petsShown = [Pet(petName: "Doggo", user: userName, petImageURL: "doggo", petState: .Featured),Pet(petName: "???", user: userName, petImageURL: "nice", petState: .Featured),Pet(petName: "Gamer", user: userName, petImageURL: "gamer", petState: .Featured),Pet(petName: "cat", user: userName, petImageURL: "waffle", petState: .Featured)]
        account = Account(userName: userName,userPosts: petsShown)
        view.addSubview(appTitleLabel)
      
        view.addSubview(userNameTextField)
        view.addSubview(loginButton)
        view.backgroundColor = .white
        loginButton.center = view.center
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
       setupConstraints()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            appTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -50),
   
        ])
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor,constant: 20),
            userNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameTextField.widthAnchor.constraint(equalToConstant: 240),
            userNameTextField.heightAnchor.constraint(equalToConstant: 42),
        ])
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor,constant: 10),
            loginButton.widthAnchor.constraint(equalToConstant: 120),
            loginButton.heightAnchor.constraint(equalToConstant: 36),
        ])
    }

    @objc func login(){
        print("LOGIN!!")
        userName = userNameTextField.text ?? "Bob123";
        
        account = Account(userName: userName,userPosts: petsShown)
      
        let tabBarVC = UITabBarController();
        
        let homeVC = UINavigationController(rootViewController: HomeViewController(petsShown: petsShown))
        let voteVC = UINavigationController(rootViewController: VoteViewController())
        let newImageVC = UINavigationController(rootViewController: NewImageViewController())
        let giveNameVC = UINavigationController(rootViewController: GiveNamesViewController())
        let accountVC = UINavigationController(rootViewController: AccountViewController(account: account))
        homeVC.title = "Home"
        voteVC.title = "Vote"
        newImageVC.title = "Add Image"
        giveNameVC.title = "Give Name"
        accountVC.title = "Account"

        tabBarVC.setViewControllers([homeVC,voteVC,newImageVC,giveNameVC,accountVC], animated: false)
        let items:[UITabBarItem] = tabBarVC.tabBar.items ?? [UITabBarItem()];


        let images = ["house", "tray.and.arrow.down.fill", "plus.circle.fill", "rectangle.and.pencil.and.ellipsis","person.crop.circle"]
        for i in 0..<items.count{
            
            items[i].image = UIImage(systemName: images[i])
        }
        print(items)
       
        tabBarVC.modalPresentationStyle = .fullScreen
        print(tabBarVC)
        
        present(tabBarVC, animated: true)
    }

}
