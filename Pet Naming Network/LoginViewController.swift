//
//  LoginViewController.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 11/30/21.
//

import UIKit

class LoginViewController: UIViewController {


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
        textField.addTarget(self, action: #selector(resignFirstResponder), for: .editingDidEndOnExit)
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = .secondarySystemFill
        textField.translatesAutoresizingMaskIntoConstraints = false;
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 20;
      
        return textField;
    }()
    
    private let loginButton:UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.setTitle("Log In", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false;
        
        return button
    }()
    
   // private var spinner = UIActivityIndicatorView()
    private var myActivityIndicator = UIActivityIndicatorView(style: .large)
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        myActivityIndicator.isHidden = true
        view.addSubview(appTitleLabel)
      
       
        
        view.addSubview(userNameTextField)
        view.addSubview(loginButton)
        view.addSubview(myActivityIndicator)
//
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//      //  spinner.center = self.view.center
//        spinner.isHidden = true;
//        spinner.backgroundColor = .clear
//        spinner.hidesWhenStopped = true;
//        spinner.style = .large
//        spinner.color = UIColor.red
//        view.addSubview(spinner)
//
                
        view.backgroundColor = .white
        loginButton.center = view.center
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        print("Please Work");
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
//        NSLayoutConstraint.activate([
//            spinner.topAnchor.constraint(equalTo: loginButton.bottomAnchor,constant: 20),
//            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//        ])
    }
    @objc func login2(){
        myActivityIndicator.isHidden = false;
        myActivityIndicator.startAnimating()
        login();
    }
    @objc func login(){

//        spinner.isHidden = false;
//        spinner.startAnimating()
//        self.view.isUserInteractionEnabled = false;
//
        
        
        myActivityIndicator.isHidden = false;
       
        userName = userNameTextField.text ?? "";
        if(userName.elementsEqual("")){
            print("Deny!")
           // loginButton.shake();
        }else{
        loginButton.startAnimatingPressActions()
        

            petsShown = [Pet(petName: "Doggo", user: userName, petImageURL: "doggo", petState: .FEATURED),Pet(petName: "???", user: userName, petImageURL: "nice", petState: .FEATURED),Pet(petName: "Gamer", user: userName, petImageURL: "gamer", petState: .FEATURED),Pet(petName: "cat", user: userName, petImageURL: "waffle", petState: .FEATURED),Pet(petName: "cat", user: userName, petImageURL: "waffle", petState: .FEATURED),Pet(petName: "cat", user: userName, petImageURL: "waffle", petState: .FEATURED),Pet(petName: "cat", user: userName, petImageURL: "waffle", petState: .FEATURED)]
        account = Account(userName: userName,userPosts: petsShown)
        
        let tabBarVC = TabBarController(account:account)
        
        let homeVC = HomeViewController(petsShown: petsShown)
        let newImageVC = NewImageViewController()
        //let homeVC = UINavigationController(rootViewController: HomeViewController(petsShown: petsShown))
        //let newImageVC = UINavigationController(rootViewController: NewImageViewController())
        let actionVC = UINavigationController(rootViewController: ActionViewController())
        
        homeVC.title = "Home"
        newImageVC.title = "New"
        actionVC.title = "Name/Vote"

        tabBarVC.setViewControllers([homeVC,newImageVC,actionVC], animated: false)
        let items:[UITabBarItem] = tabBarVC.tabBar.items ?? [UITabBarItem()];

        //"tray.and.arrow.down.fill",
        //,"person.crop.circle"
        let images = ["house",  "plus.circle.fill", "highlighter"]
        for i in 0..<items.count{
            
            items[i].image = UIImage(systemName: images[i])
        }
        
          
        self.navigationController?.pushViewController(tabBarVC, animated: true)
        }
        myActivityIndicator.stopAnimating()
    }
        
    
}
