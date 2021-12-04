//
//  LoginViewController.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 11/30/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var adjs  = ["Wild", "Foregoing", "Talented", "Mysterious", "Incredible", "Gorgeous", "Dazzling", "Inquisitive", "Wealthy", "Educated", "Wrathful", "Axiomatic"]
    private var nouns = ["Copper", "Building", "Harbor", "Flock", "Yarn", "Carpenter", "Pear", "Grain", "Ocean", "Yam", "Scent", "Toys", "Celery", "Education", "Toe", "Snow"]
    
    private var userName:String = "Bob123"
    
    public static var petServer:PetServer!;
    
    private var welcomeLabel:UILabel = {
        let label = UILabel()
        label.text = "Welcome to the"
        label.font = .systemFont(ofSize: 24, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var petsShown:[Pet] = []
    private var appTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "Pet Naming Network"
        label.font = .boldSystemFont(ofSize: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var infoLabel:UILabel = {
        let label = UILabel()
        label.text = "Welcome! Enter your username below, create a new one if you don't have one already, or create a new random one with the button below."
        label.font = .systemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var userNameTextField:UITextField = {
        let textField = UITextField();
        textField.text = nil
        textField.placeholder = "Enter your username, or create a new one"
        textField.font = .systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(resignFirstResponder), for: .editingDidEndOnExit)
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = .secondarySystemFill
        textField.translatesAutoresizingMaskIntoConstraints = false;
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 20;
        
        return textField;
    }()
    
    private var loginButton:UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.setTitle("Log In", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var randomButton:UIButton = {
        let button = UIButton()
        button.configuration = .gray()
        button.setTitle("Random Name", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var disclaimerView:UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var disclaimerLabel:UILabel = {
        let label = UILabel()
        label.text = "Disclaimer: For the purposes of this hack challenge, we're not using passwords."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 4
        return label
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
        
        view.addSubview(welcomeLabel)
        view.addSubview(infoLabel)
        view.addSubview(userNameTextField)
        view.addSubview(randomButton)
        view.addSubview(loginButton)
        view.addSubview(myActivityIndicator)
        view.addSubview(disclaimerView)
        disclaimerView.addSubview(disclaimerLabel)
        
        view.backgroundColor = .systemBackground
        loginButton.center = view.center
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        randomButton.addTarget(self, action: #selector(newRandomName), for: .touchUpInside)
        setupConstraints()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        NSLayoutConstraint.activate([
            appTitleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 0),
            appTitleLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 30),
            infoLabel.leadingAnchor.constraint(equalTo: appTitleLabel.leadingAnchor),
            infoLabel.widthAnchor.constraint(equalToConstant: view.frame.width-40),
            //infoLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor,constant: 40),
            userNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameTextField.widthAnchor.constraint(equalToConstant: view.frame.width-40),
            userNameTextField.heightAnchor.constraint(equalToConstant: 42),
        ])
        NSLayoutConstraint.activate([
            randomButton.leadingAnchor.constraint(equalTo: userNameTextField.leadingAnchor),
            randomButton.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor,constant: 20),
            randomButton.widthAnchor.constraint(equalToConstant: view.frame.width/2-25),
            randomButton.heightAnchor.constraint(equalToConstant: 42),
        ])
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: randomButton.trailingAnchor, constant: 10),
            loginButton.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor,constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: view.frame.width/2-25),
            loginButton.heightAnchor.constraint(equalToConstant: 42),
        ])
        NSLayoutConstraint.activate([
            disclaimerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //disclaimerView.leadingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: 10),
            disclaimerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20),
            disclaimerView.widthAnchor.constraint(equalToConstant: view.frame.width-40),
            disclaimerView.heightAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            //disclaimerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //disclaimerView.leadingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: 10),
            disclaimerLabel.topAnchor.constraint(equalTo: disclaimerView.topAnchor),
            disclaimerLabel.widthAnchor.constraint(equalToConstant: view.frame.width-60),
            disclaimerLabel.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        
        //        NSLayoutConstraint.activate([
        //            spinner.topAnchor.constraint(equalTo: loginButton.bottomAnchor,constant: 20),
        //            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        //
        //        ])
    }
    @objc func newRandomName() {
        let randAdj = adjs.randomElement()!
        let randNoun = nouns.randomElement()!
        let randNum = Int.random(in: 1...1000)
        let randName = randAdj + randNoun + String(randNum)
        userNameTextField.text = randName
        login()
    }
    
    var check = 0;
    @objc func login(){
        userName = userNameTextField.text ?? "";
        
        
        if(!userName.elementsEqual("")){
            NetworkManager.loginAccount(username: userName, completion: { user in
                if user.loggedIn == 1{
                    PetServer.account = Account(user: user)
                    
                    self.createTabs()
                }else{
                    NetworkManager.createAccount(username: self.userName, completion: { user in
                        PetServer.account = Account(user: user)

                        self.createTabs()
                    })
                }
                
                
            })
            
        }else{
            print("Deny!")
        }
        
    }
    
    func createTabs(){
        loginButton.startAnimatingPressActions()
        
        petsShown = []
        
        LoginViewController.petServer = PetServer();
        
    
        NetworkManager.getPetsNaming{ pets in

            LoginViewController.petServer.petsNaming = pets;
            NetworkManager.getPetsVoting{ pets2 in
      
                LoginViewController.petServer.petsVoting = pets2;
                
                let tabBarVC = TabBarController(account:PetServer.account)
                let homeVC = HomeViewController(petsShown: self.petsShown)
                let newImageVC = NewImageViewController()
                let actionVC = UINavigationController(rootViewController: ActionViewController())
                
                homeVC.title = "Home"
                newImageVC.title = "New"
                actionVC.title = "Name/Vote"
                
                tabBarVC.setViewControllers([homeVC,newImageVC,actionVC], animated: false)
                let items:[UITabBarItem] = tabBarVC.tabBar.items ?? [UITabBarItem()];
                
                let images = ["house",  "plus.circle.fill", "highlighter"]
                for i in 0..<items.count{
                    items[i].image = UIImage(systemName: images[i])
                }
                
                
                
                self.navigationController?.pushViewController(tabBarVC, animated: true)
                
                
                
            }
        }
        
        
        
       
    }
    
}



