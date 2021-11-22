//
//  AccountViewController.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 11/18/21.
//

import UIKit

class AccountViewController: UIViewController {

    var imagePicker: ImagePicker!
    
    private var petsPostedCollectionView:UICollectionView!;
    
    private var profilePic:UIButton = UIButton();
    private var userName:UITextView = UITextView();
    private var background:UIView = UIView();
  
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
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        userName.text = account.userName
        userName.textColor = .black
        userName.textAlignment = .center
        userName.font = .boldSystemFont(ofSize: 20)
        userName.layer.backgroundColor = UIColor.systemGray6.cgColor
        userName.translatesAutoresizingMaskIntoConstraints = false;
        userName.layer.cornerRadius = 20;
        
        view.addSubview(userName)
        
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.setTitle("P", for: .normal)
        profilePic.setTitleColor(.black, for: .normal)
        profilePic.backgroundColor = account.bgColor
        profilePic.layer.borderColor = UIColor.white.cgColor
        profilePic.layer.borderWidth = 8
        profilePic.layer.cornerRadius = width/2
        profilePic.layer.masksToBounds = true;
        profilePic.titleLabel?.font = .boldSystemFont(ofSize: 50)
        profilePic.titleLabel?.textColor = .white;
        
        
        
        
        profilePic.addTarget(self, action: #selector(editProfilePicture), for: .touchUpInside)
        background = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/2))
        background.backgroundColor = account.bgColor
        
        background.dropShadow()
        
        view.addSubview(background)
        background.addSubview(profilePic)
        
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
    @objc func editProfilePicture(_ sender: UIButton){
       print("HELLO!")
        self.imagePicker.present(from: sender)
    }
    func setUpViews() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.heightAnchor.constraint(equalToConstant: view.frame.size.height/2),
        ])
        

        NSLayoutConstraint.activate([
            profilePic.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            profilePic.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            profilePic.widthAnchor.constraint(equalToConstant: width),
            profilePic.heightAnchor.constraint(equalToConstant: width),
        ])
        NSLayoutConstraint.activate([
            userName.topAnchor.constraint(equalTo: background.bottomAnchor,constant: 5),
            userName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userName.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            userName.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            userName.heightAnchor.constraint(equalToConstant:40)
        ])
        let collectionViewPadding: CGFloat = 12
        NSLayoutConstraint.activate([
            petsPostedCollectionView.topAnchor.constraint(equalTo: userName.topAnchor,constant:30),
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
        cell.accountConfigure(for: account.userPosts[indexPath.row]);
            
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
        
            let numItemsPerRow: CGFloat = 3.1
            let size = (collectionView.frame.width - cellPadding) / numItemsPerRow
            return CGSize(width: size, height: (size))
       
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       
            return CGSize(width: collectionView.frame.width, height: 50)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = PetViewController(pet: account.userPosts[indexPath.item]);
            present(vc, animated: true, completion: nil)
       
    }
}

extension UIView {
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
extension AccountViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        account.userPFP = image ?? UIImage();
        self.profilePic.setImage(image, for: UIControl.State.normal)
    }
}
