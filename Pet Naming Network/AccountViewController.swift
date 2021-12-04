//
//  AccountViewController.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 11/18/21.
//

import UIKit

class AccountViewController: UIViewController {

    var imagePicker: ImagePicker!
    
    // ============== Tables and Collection View ==============
    private var petsPostedCollectionView:UICollectionView!;
    private var namesTableView:UITableView = UITableView();
    
    /*
        ===================== UI Elements =====================
     */
    private var profilePic:UIButton = UIButton()
    private var userName:UITextView = UITextView()
    private var background:UIView = UIView()
    private var closeButton = UIButton(type: .close)
    private var actionControl = UISegmentedControl(items: ["Pets Uploaded", "Names Suggested"])
   
    
    /*
        ===================== Parameters =====================
     */
    private var reuseIdentifier = "namesCellReuse"
    private var petPostCellReuseIdentifier = "petPostCellReuseIdentifier"
    private let headerReuseIdentifier = "headerReuseIdentifer2"
    private let cellPadding: CGFloat = 10
    private let sectionPadding: CGFloat = 5
    private let collectionViewPadding: CGFloat = 12
    
    var names:[String] = ["dummy1","dummy2","dummy3","dummy4","dummy5"]
    var votes:[Int] = [1,2,3,4,5];
    let cellHeight:CGFloat = 50;
    var width:CGFloat = 150.0;
    
    private var account:Account;
    
    init(account:Account){
        self.account=account;
        let c:String = account.userName[account.userName.index(account.userName.startIndex, offsetBy: 0)].uppercased()
        let pic: UIImage = HomeViewController.DefaultPFP[c] ?? UIImage()
       profilePic.setImage(pic, for: UIControl.State.normal)
       
        super.init(nibName: nil, bundle: nil)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = account.userName
        view.backgroundColor = .systemGray6
        
        // Action Control
        actionControl.selectedSegmentIndex = 0
        actionControl.addTarget(self, action: #selector(changeViews), for: .valueChanged)
        actionControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(actionControl)
        
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
        
        background = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/3))
        background.backgroundColor = account.bgColor
        
        background.dropShadow()
        
        view.addSubview(background)
        background.addSubview(profilePic)
        
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        background.addSubview(closeButton)
        
        
        
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
        
        namesTableView.backgroundColor = .clear
        namesTableView.translatesAutoresizingMaskIntoConstraints = false
        namesTableView.dataSource = self
        namesTableView.delegate = self
        namesTableView.register(NamesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        namesTableView.isScrollEnabled=true;
        namesTableView.showsVerticalScrollIndicator = true;
        view.addSubview(namesTableView)
        namesTableView.reloadData()
        namesTableView.isHidden = true;
        
        setUpViews()
       
        NSLayoutConstraint.activate([
            petsPostedCollectionView.topAnchor.constraint(equalTo: actionControl.bottomAnchor,constant:5),
            petsPostedCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            petsPostedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: collectionViewPadding),
            petsPostedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -collectionViewPadding)
        ])
        NSLayoutConstraint.activate([
            namesTableView.topAnchor.constraint(equalTo: actionControl.bottomAnchor,constant:5),
            namesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            namesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: collectionViewPadding),
            namesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -collectionViewPadding)
        ])

        
    }
    func reloadAccountData(){
        petsPostedCollectionView.reloadData()
        
    }
    @objc func editProfilePicture(_ sender: UIButton){
        self.imagePicker.present(from: sender)
    }
    
    @objc func closeView() {
        dismiss(animated: true, completion: nil)
    }
    @objc func changeViews() {
        if actionControl.selectedSegmentIndex == 0 {
            namesTableView.isHidden = true;
            petsPostedCollectionView.isHidden = false;
        }
        else if actionControl.selectedSegmentIndex == 1 {
            namesTableView.isHidden = false;
            petsPostedCollectionView.isHidden = true;
        }
    }
    func setUpViews() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.heightAnchor.constraint(equalToConstant: view.frame.size.height/5),
        ])
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
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
        NSLayoutConstraint.activate([
            actionControl.topAnchor.constraint(equalTo: userName.bottomAnchor,constant:5),
            actionControl.widthAnchor.constraint(equalToConstant: self.view.frame.width-20)
            
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
extension AccountViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NamesTableViewCell {
            let name = names[indexPath.row]
            let vote = votes[indexPath.row]
            cell.configure(name: name,votes: vote)
            cell.selectionStyle = .none
            
            return cell
        } else {
            return UITableViewCell()
        }
    }

}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  cellHeight;
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let song = names[indexPath.row]
//
//        if let cell = tableView.cellForRow(at: indexPath) as? NamesTableViewCell {
//            print("Cell Test In: \(cell)")
//            let vc = SongViewController(delegate: self, song: song, cell:cell, index: indexPath.row)
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//
//    }
}

