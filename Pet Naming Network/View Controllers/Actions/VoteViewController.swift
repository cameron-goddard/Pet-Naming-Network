//
//  VoteViewController.swift
//  Pet Naming Network
//
//  Created by Cameron Goddard on 12/2/21.
//

import UIKit

class VoteViewController: UIViewController {
    
    private var imageView = UIImageView()
    private var namesTableView = UITableView()
    private var skipButton = UIButton()
    let userName = "test"
    
    private var votableNames : [PetName] = []
    private var index = 0;
    private var name:String = "";
    
    private let reuseIdentifier = "votableNameCellReuse"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        
        namesTableView.tableHeaderView = UIView()
        namesTableView.alwaysBounceVertical = false
        namesTableView.layer.cornerRadius = 10
        namesTableView.delegate = self
        namesTableView.dataSource = self
        namesTableView.register(VotableNameTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        namesTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(namesTableView)
        
        //imageView.image = UIImage(named: "doggo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        skipButton.configuration = .filled()
        skipButton.configuration?.buttonSize = .large
        skipButton.setTitle("Skip Image", for: .normal)
        skipButton.tag = -1
        skipButton.addTarget(self, action: #selector(nextImage), for: .touchUpInside)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(skipButton)
        setupPets()
        setUpConstraints()
    }
    public func setupPets(){
        if(!LoginViewController.petServer.petsVoting.isEmpty){
            votableNames = LoginViewController.petServer.petsVoting[0].names
            imageView.image = Pet(petPost:LoginViewController.petServer.petsVoting[0]).petImage
        }
    }
    
    public func refresh(){
        index = -1;
        nextImage()
        namesTableView.reloadData()
    }
    
    @objc func nextImage(){
        self.index = self.index + 1;
        if(self.index >= LoginViewController.petServer.petsVoting.count){
            self.index = 0;
        }
    
        if(LoginViewController.petServer.petsVoting.isEmpty){
            skipButton.setTitle("No images to vote on", for: .normal)
            UIView.transition(with: imageView, duration: 1.0, options: .transitionFlipFromLeft, animations: {
                self.imageView.image = UIImage(systemName: "photo")
            }, completion: nil)
            
            UIView.transition(with: namesTableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.votableNames = []
                self.namesTableView.reloadData()
            }, completion: nil)
        }else{
            skipButton.setTitle("Skip Image", for: .normal)
            pet = Pet(petPost:LoginViewController.petServer.petsVoting[self.index])
        
            UIView.transition(with: self.imageView, duration: 1.0, options: .transitionFlipFromLeft, animations: {
                
                self.imageView.image = self.pet.petImage
            }, completion: nil)
            
            UIView.transition(with: self.namesTableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.votableNames = LoginViewController.petServer.petsVoting[self.index].names
                self.namesTableView.reloadData()
            }, completion: nil)
        }
    }
    
    var pet:Pet!;
    @objc func newImage(_ sender: UIButton) {
        if sender.tag != -1 {
            
        }
        
        let name:String = votableNames[sender.tag].name
        if(!LoginViewController.petServer.petsVoting.isEmpty){
            
        
        NetworkManager.addVote(name: name, petID: pet.id, completion: {pet in
            PetServer.account.updateAccount()
            LoginViewController.petServer.updateServer()
            DispatchQueue.main.async {
                
                self.nextImage();
            }
        })
        }else{
            PetServer.account.updateAccount()
            LoginViewController.petServer.updateServer()
            self.nextImage()
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
            namesTableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            namesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            namesTableView.widthAnchor.constraint(equalToConstant: view.frame.width-40),
            namesTableView.heightAnchor.constraint(equalToConstant: CGFloat(votableNames.count*60))
        ])
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: namesTableView.bottomAnchor, constant: 20),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: view.frame.width-40)
        ])
    }
}

extension VoteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return votableNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? VotableNameTableViewCell {
            cell.voteButton.addTarget(self, action: #selector(newImage(_:)), for: .touchUpInside)
            cell.voteButton.tag = indexPath.row
            
            cell.dislikeButton.addTarget(self, action: #selector(hideName(_:)), for: .touchUpInside)
            cell.dislikeButton.tag = indexPath.row
            cell.selectionStyle = .none
            let pet = votableNames[indexPath.row]
            //cell.voteButton.titleLabel?.text = pet.name
            cell.configure(name: pet.name)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let hideAction = UIContextualAction(style: .destructive, title: "Hide") { [weak self] (hideAction, view, completionHandler) in
            self?.deleteAtIndex(index: indexPath.row)
            completionHandler(true)
        }
        hideAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [hideAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let voteAction = UIContextualAction(style: .normal, title: "Vote") { [weak self] (voteAction, view, completionHandler) in
            self?.deleteAtIndex(index: indexPath.row)
            completionHandler(true)
        }
        voteAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [voteAction])
    }
    
    @objc func hideName(_ sender: UIButton) {
        votableNames.remove(at: sender.tag)
        namesTableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .left)
        namesTableView.reloadData()
    }
}

extension VoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func deleteAtIndex(index: Int) { //For deleting a song (on swipe)
        votableNames.remove(at: index)
        namesTableView.reloadData()
    }
}
