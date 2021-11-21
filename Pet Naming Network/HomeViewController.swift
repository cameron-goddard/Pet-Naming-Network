//
//  ViewController.swift
//  Pet Naming Network
//
//  Created by Cameron Goddard on 11/11/21.
//

import UIKit

class HomeViewController: UITabBarController, UITabBarControllerDelegate{

    private var petCollectionView:UICollectionView!;
    
    public static var DefaultPFP:[String:UIImage]{
        let alpha:String = "ABCDEFGHIJKMNLOPQRSTUVWXYZ";
        var images:[String:UIImage] = [:];
        for i in 1...26{
            let s:String = alpha[alpha.index(alpha.startIndex, offsetBy: i-1)].uppercased()
            images[s] = UIImage(named: "alphabet_\(i)") ?? UIImage()
        }
        return images;
    };
    
    
    
    private var petsShown:[Pet] = [Pet(petName: "Doggo", user: "SharkLord777", petImageURL: "doggo", petState: .Featured),Pet(petName: "???", user: "SharkLord777", petImageURL: "nice", petState: .Featured),Pet(petName: "Gamer", user: "SharkLord777", petImageURL: "gamer", petState: .Featured)]
    private var account:Account = Account(userName: "", userPosts: []);
    
    
    
    private var petCellReuseIdentifier = "petCellReuseIdentifier"
    private let headerReuseIdentifier = "headerReuseIdentifer"
    private let cellPadding: CGFloat = 10
    private let sectionPadding: CGFloat = 5
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Featured"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        self.delegate = self
        view.backgroundColor = .systemBackground
        
        
        account = Account(userName: "SharkLord777",userPosts: petsShown)
        
        petCollectionView = {
            let layout = UICollectionViewFlowLayout();
            layout.scrollDirection = .vertical;
            layout.minimumLineSpacing = cellPadding
            layout.minimumInteritemSpacing = cellPadding
            let collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout);
            collectionView.backgroundColor = .clear
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.register(PetCollectionViewCell.self, forCellWithReuseIdentifier: petCellReuseIdentifier)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
            return collectionView;
        }()
        
        view.addSubview(petCollectionView);
        instantiateButtons();
        setupConstraints()
    }
    func setupConstraints() {
        let collectionViewPadding: CGFloat = 12
        NSLayoutConstraint.activate([
            petCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            petCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            petCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: collectionViewPadding),
            petCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -collectionViewPadding)
        ])
        
    }
    func instantiateButtons(){
        let importAction = UIAction(title: "Import", image: UIImage(systemName: "folder")) { action in }
        
        let sortButton = UIBarButtonItem(
            title: "Sort",
            image: UIImage(named: "line.3.horizontal.decrease.circle"),
            primaryAction: nil,
            menu: UIMenu(title: "", children: [importAction])
            )
        self.navigationItem.leftBarButtonItem = sortButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "person.crop.circle"), style: .plain, target: self, action: #selector(presentAccount))
        
    }
    
    
    @objc func presentAccount(){
        let vc = AccountViewController(account: account);
        present(vc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let voteVC = VoteViewController()
        let voteTabBarItem = UITabBarItem(title: "Vote", image: UIImage(systemName: "tray.and.arrow.down.fill"), selectedImage: UIImage(systemName: "tray.and.arrow.down.fill"))
        voteVC.tabBarItem = voteTabBarItem
        
        let newImageVC = NewImageViewController()
        let newImageTabBarItem = UITabBarItem(title: "New", image: UIImage(systemName: "plus.circle.fill"), selectedImage: UIImage(systemName: "plus.circle.fill"))
        newImageVC.tabBarItem = newImageTabBarItem
        
        let giveNamesVC = VoteViewController()
        let giveNamesTabBarItem = UITabBarItem(title: "Name", image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis"), selectedImage: UIImage(systemName: "rectangle.and.pencil.and.ellipsis"))
        giveNamesVC.tabBarItem = giveNamesTabBarItem
        
        self.viewControllers = [voteVC, newImageVC, giveNamesVC]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("Selected \(viewController.title!)")
    }
}
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petsShown.count
      
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: petCellReuseIdentifier, for: indexPath) as! PetCollectionViewCell
            cell.configure(for: petsShown[indexPath.row]);
            
            return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! HeaderView
       
            header.configure(for: "Featured Pets")
            return header
        
    }
    
    
}
extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let numItemsPerRow: CGFloat = 2
            let size = (collectionView.frame.width - cellPadding) / numItemsPerRow
        return CGSize(width: size, height: (size*3)/2-40)
       
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       
            return CGSize(width: collectionView.frame.width, height: 50)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
    }
}



