//
//  AccountViewController.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 11/18/21.
//

import UIKit

class AccountViewController: UIViewController {

    private var petsPostedCollectionView:UICollectionView!;
    
    private var profilePic:UIButton = UIButton();
    private var userName:UITextView = UITextView();
    private var petPostCellReuseIdentifier = "petPostCellReuseIdentifier"
    private let headerReuseIdentifier = "headerReuseIdentifer2"
    private let cellPadding: CGFloat = 10
    private let sectionPadding: CGFloat = 5
    var width:CGFloat = 150.0;
    private var account:Account;
    
    init(account:Account){
        self.account=account;
        let c:String = account.userName[account.userName.index(account.userName.startIndex, offsetBy: 0)].uppercased()
        let pic: UIImage = HomeViewController.DefaultPFP[c] ?? UIImage()
  
        profilePic.setImage(pic, for: UIControl.State.normal)
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemGray6
        userName.text = account.userName
        userName.textColor = .black
        userName.font = .systemFont(ofSize: 14)
        userName.layer.backgroundColor = UIColor.systemGray6.cgColor
        userName.translatesAutoresizingMaskIntoConstraints = false;
        userName.layer.cornerRadius = 20;
        
        view.addSubview(userName)
        
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.setTitle("PFP", for: .normal)
        profilePic.setTitleColor(.black, for: .normal)
        profilePic.backgroundColor = .red
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.borderWidth = 8
        profilePic.layer.cornerRadius = width/2
        profilePic.layer.masksToBounds = true;
        
        profilePic.addTarget(self, action: #selector(editProfilePicture), for: .touchUpInside)
        view.addSubview(profilePic)
        
        
        petsPostedCollectionView = {
            let layout = UICollectionViewFlowLayout();
            layout.scrollDirection = .vertical;
            layout.minimumLineSpacing = cellPadding
            layout.minimumInteritemSpacing = cellPadding
            let collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout);
            collectionView.backgroundColor = .clear
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.register(PetCollectionViewCell.self, forCellWithReuseIdentifier: petPostCellReuseIdentifier)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
            return collectionView;
        }()
        
        view.addSubview(petsPostedCollectionView);
        
        setUpViews()
    }
    @objc func editProfilePicture(){
       print("HELLO!")
    }
    func setUpViews() {
        NSLayoutConstraint.activate([
            profilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profilePic.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.size.height/8),
            profilePic.widthAnchor.constraint(equalToConstant: width),
            profilePic.heightAnchor.constraint(equalToConstant: width)
        ])
        NSLayoutConstraint.activate([
            userName.topAnchor.constraint(equalTo: profilePic.bottomAnchor,constant: 20),
            userName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userName.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            userName.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            userName.heightAnchor.constraint(equalToConstant:40)
        ])
        let collectionViewPadding: CGFloat = 12
        NSLayoutConstraint.activate([
            petsPostedCollectionView.topAnchor.constraint(equalTo: userName.topAnchor,constant:20),
            petsPostedCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            petsPostedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: collectionViewPadding),
            petsPostedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -collectionViewPadding)
        ])
    }
    
    
}
extension AccountViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return account.userPosts.count
      
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: petPostCellReuseIdentifier, for: indexPath) as! PetCollectionViewCell
        cell.configure(for: account.userPosts[indexPath.row]);
            
            return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! HeaderView
       
            header.configure(for: "Pets Posted")
            return header
        
    }
    
    
}
extension AccountViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let numItemsPerRow: CGFloat = 2.0
            let size = (collectionView.frame.width - cellPadding) / numItemsPerRow
            return CGSize(width: size, height: (size*3)/2-10)
       
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       
            return CGSize(width: collectionView.frame.width, height: 50)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
    }
}




