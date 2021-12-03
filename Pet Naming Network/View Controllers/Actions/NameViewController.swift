//
//  NameViewController.swift
//  Pet Naming Network
//
//  Created by Cameron Goddard on 12/2/21.
//

import UIKit

class NameViewController: UIViewController {

    private var imageView = UIImageView()
    private var nameTextField = UITextField()
    private var submitButton = UIButton()
    private var skipButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        nameTextField.textColor = .label
        nameTextField.font = .systemFont(ofSize: 14)
        nameTextField.borderStyle = .roundedRect
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.backgroundColor = .secondarySystemFill
        nameTextField.placeholder = "Enter your name for this image"
        nameTextField.addTarget(self, action: #selector(resignFirstResponder), for: .editingDidEndOnExit)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        submitButton.configuration = .filled()
        submitButton.configuration?.buttonSize = .large
        submitButton.setTitle("Submit Name", for: .normal)
        submitButton.addTarget(self, action: #selector(submitName), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
        
        skipButton.configuration = .filled()
        skipButton.configuration?.buttonSize = .large
        skipButton.setTitle("Skip Name", for: .normal)
        skipButton.addTarget(self, action: #selector(skipName), for: .touchUpInside)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(skipButton)
        
        setUpConstraints()
    }
    
    @objc func submitName() {
        //process name
        nextImage()
    }
    
    @objc func skipName() {
        
        nextImage()
    }
    
    func nextImage() {
        nameTextField.text = ""
        
        UIView.transition(with: imageView, duration: 1.0, options: .transitionFlipFromLeft, animations: {
            self.imageView.image = UIImage(systemName: "bolt.ring.closed")
        
        }, completion: nil)
    }
    
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width-40),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: view.frame.width-40)
        ])
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: view.frame.width-40)
        ])
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: view.frame.width-40)
        ])
        
    }
}
