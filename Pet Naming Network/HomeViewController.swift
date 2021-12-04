//
//  ViewController.swift
//  Pet Naming Network
//
//  Created by Cameron Goddard on 11/11/21.
//

import UIKit

class HomeViewController: UIViewController{

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
    
    private var petsShown:[Pet] = []
  
    init(petsShown:[Pet]){
//        self.petsShown = [];
       
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var petCellReuseIdentifier = "petCellReuseIdentifier"
    private let headerReuseIdentifier = "headerReuseIdentifer"
    private let cellPadding: CGFloat = 15
    private let sectionPadding: CGFloat = 5
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HELLO YOU TURN RED!!")
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        createData();
      
        petCollectionView = {
            let layout = UICollectionViewFlowLayout();
            layout.scrollDirection = .vertical;
            layout.minimumLineSpacing = cellPadding
            layout.minimumInteritemSpacing = cellPadding
            let collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.delaysContentTouches = false
            collectionView.backgroundColor = .clear
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.register(PetCollectionViewCell.self, forCellWithReuseIdentifier: petCellReuseIdentifier)
            collectionView.contentInset = UIEdgeInsets(top: 0, left: cellPadding, bottom: cellPadding, right: cellPadding)

            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
            return collectionView
        }()
        petCollectionView.backgroundColor = .systemBackground
        
        view.addSubview(petCollectionView);
        
        if #available(iOS 10.0, *) {
            petCollectionView.refreshControl = refreshControl
        } else {
            petCollectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
       
        setupConstraints()
    }
    
    func createData(){
        NetworkManager.getFeaturedPets{ pets in
        DispatchQueue.main.async {
            for x in 0..<pets.count{
                self.petsShown.append(Pet(petPost:pets[x]))
            }

            self.petCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.title = "Featured"
        refreshData()
    }
    
    func setupConstraints() {
        let collectionViewPadding: CGFloat = 0
        NSLayoutConstraint.activate([
            petCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            petCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            petCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: collectionViewPadding),
            petCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -collectionViewPadding),
            //petCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //petCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        ])
        
    }
    @objc func refreshData() {
        NetworkManager.getFeaturedPets{ pets in
            self.petsShown.removeAll()
            for x in 0..<pets.count{
                self.petsShown.append(Pet(petPost:pets[x]))
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
                self.petCollectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
            
        }
        
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
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 10.0
            cell.layer.shadowOpacity = 0.2
            cell.layer.masksToBounds = false
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
            let size = (collectionView.frame.width - cellPadding*3) / numItemsPerRow
        return CGSize(width: size, height: (size*3)/2-50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PetViewController(pet: petsShown[indexPath.item]);
            present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? PetCollectionViewCell {
                let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
                PetCollectionViewCell.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: animationOptions, animations: {
                    cell.transform = .init(scaleX: 0.96, y: 0.96)
                }, completion: nil)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? PetCollectionViewCell {
                let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
                PetCollectionViewCell.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: animationOptions, animations: {
                    cell.transform = .identity
                }, completion: nil)
            }
        }
    }
}



