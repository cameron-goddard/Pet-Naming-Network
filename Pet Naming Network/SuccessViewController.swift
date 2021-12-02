//
//  SuccessViewController.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 12/1/21.
//

import UIKit

class SuccessViewController: UIViewController {

    
    private var successImageView = UIImageView();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        successImageView.image = UIImage(named: "success")
        successImageView.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(successImageView)
        setupConstraints()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            successImageView.heightAnchor.constraint(equalToConstant: view.frame.size.width),
            successImageView.widthAnchor.constraint(equalToConstant: view.frame.size.width)
        ])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
