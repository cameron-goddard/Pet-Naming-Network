//
//  SuccessViewController.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 12/1/21.
//

import UIKit

class SuccessViewController: UIViewController {

    
    private var successImageView = UIImageView();
    private var successLabel1 = UILabel();
    private var successLabel2 = UILabel();
    private var closeButton = UIButton(type: .close)
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        successImageView.image = UIImage(named: "success")
        successImageView.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(successImageView)
        
        successLabel1.text = "Your Pet Has"
        successLabel1.textAlignment = .center
        successLabel1.font = UIFont.boldSystemFont(ofSize: 32)
        successLabel1.textColor = .orange
        successLabel1.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(successLabel1)
        successLabel2.text = "Been Successfully Uploaded!"
        successLabel2.textAlignment = .center
        successLabel2.font = UIFont.boldSystemFont(ofSize: 32)
        successLabel2.textColor = .orange
        successLabel2.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(successLabel2)
        
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            successImageView.heightAnchor.constraint(equalToConstant: view.frame.size.width),
            successImageView.widthAnchor.constraint(equalToConstant: view.frame.size.width)
        ])
        NSLayoutConstraint.activate([
            successLabel1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successLabel1.topAnchor.constraint(equalTo: successImageView.bottomAnchor,constant: 40)
        ])
        NSLayoutConstraint.activate([
            successLabel2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successLabel2.topAnchor.constraint(equalTo: successLabel1.bottomAnchor,constant: 8)
        ])
    }
    
    @objc func closeView() {
        dismiss(animated: true, completion: nil)
    }
}
