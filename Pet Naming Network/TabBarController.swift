//
//  TabBarController.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 12/1/21.
//

import UIKit

class TabBarController: UITabBarController {

    private var accountVC:AccountViewController
    
    init(account:Account){
        accountVC = AccountViewController(account: account)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = .green
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.tintColor = .systemBlue
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.green

//        tabBar.barTintColor = .green
//        tabBar.isTranslucent = false
        //tabBar.tintColor = .systemBlue
        //tabBar.unselectedItemTintColor = .systemGray
        
    
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: self, action: #selector(presentAccount))
        
        self.navigationItem.hidesBackButton=true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logOut))
    }
    
    @objc func logOut() {
        self.navigationController?.popViewController(animated: true);
    }
    
    @objc func presentAccount() {
        present(accountVC, animated: true, completion: nil)
    }
}
