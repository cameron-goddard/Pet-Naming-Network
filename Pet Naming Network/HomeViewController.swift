//
//  ViewController.swift
//  Pet Naming Network
//
//  Created by Cameron Goddard on 11/11/21.
//

import UIKit

class HomeViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        title = "Featured"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        //print(self.navigationItem.titleView.)
        
        self.delegate = self
        view.backgroundColor = .systemBackground
        
        let importAction = UIAction(title: "Import", image: UIImage(systemName: "folder")) { action in }
        
        let sortButton = UIBarButtonItem(
            title: "Sort",
            image: UIImage(named: "line.3.horizontal.decrease.circle"),
            primaryAction: nil,
            menu: UIMenu(title: "", children: [importAction])
            )
        
        self.navigationItem.leftBarButtonItem = sortButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "person.crop.circle"), style: .plain, target: self, action: nil)
        
        

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



