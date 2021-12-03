//
//  ActionViewController.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 12/1/21.
//

import UIKit

class ActionViewController: UIViewController {

    private var actionControl = UISegmentedControl(items: ["Vote", "Name"])
    
    private lazy var voteVC : VoteViewController = {
        var vc = VoteViewController()
        self.add(vc: vc)
        return vc
    }()
    
    private lazy var nameVC : NameViewController = {
        var vc = NameViewController()
        self.add(vc: vc)
        return vc
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.tabBarController?.title = "Pet Naming Network"
        
        actionControl.selectedSegmentIndex = 0
        actionControl.addTarget(self, action: #selector(changeViews), for: .valueChanged)
        actionControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionControl.widthAnchor.constraint(equalToConstant: self.view.frame.width-20)
        ])
        self.navigationItem.titleView = actionControl
        
        
        
        add(vc: voteVC)
        
        setUpConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.title = ""
    }
    
    @objc func changeViews() {
        if actionControl.selectedSegmentIndex == 0 {
            remove(vc: nameVC)
            add(vc: voteVC)
        }
        else if actionControl.selectedSegmentIndex == 1 {
            remove(vc: voteVC)
            add(vc: nameVC)
        }
    }
    
    private func add(vc: UIViewController) {
        addChild(vc)
        view.addSubview(vc.view)
        //vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        vc.didMove(toParent: self)
    }
    
    private func remove(vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    func setUpConstraints() {
        
        /*NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: actionControl.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -250)
            //containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //containerView.widthAnchor.constraint(equalToConstant: view.frame.width-40)
        ])*/
        
    }
}
