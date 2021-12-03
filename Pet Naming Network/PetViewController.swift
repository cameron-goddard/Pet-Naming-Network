//
//  PetViewController.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 11/21/21.
//

import UIKit
import SnapKit

class PetViewController: UIViewController {

    

    private var petImageView:UIImageView = UIImageView()
    private var petNameLabel:UILabel = UILabel()
    private var userNameLabel:UILabel = UILabel()
    private var closeButton = UIButton(type: .close)
    private var tableLabel:UILabel = UILabel()
    private var namesTableView:UITableView = UITableView();
    private var reuseIdentifier = "namesCellReuse"
    
    let cellHeight:CGFloat = 80;
    
    var names:[String] = [];
    private var pet:Pet
    init(pet:Pet){
        self.pet = pet;
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Pet"
        view.backgroundColor = .systemBackground
        
        for x in 0...pet.nameSuggestions.count-1{
            names.append(pet.nameSuggestions[x])
        }
        namesTableView.backgroundColor = .clear
        namesTableView.translatesAutoresizingMaskIntoConstraints = false
        namesTableView.dataSource = self
        namesTableView.delegate = self
        namesTableView.register(NamesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        namesTableView.isScrollEnabled=true;
        namesTableView.showsVerticalScrollIndicator = true;
        view.addSubview(namesTableView)
        namesTableView.reloadData()
        
        
        
        
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        petImageView.contentMode = .scaleAspectFit
        
        petImageView.image = pet.petImage;
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(petImageView)
        
        petNameLabel.text = pet.petName
        petNameLabel.textAlignment = .center
        petNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        petNameLabel.textColor = .orange
        petNameLabel.translatesAutoresizingMaskIntoConstraints = false;
 
        view.addSubview(petNameLabel)
    
        
        userNameLabel.text = pet.user
        
        userNameLabel.textAlignment = .center
        userNameLabel.font = .systemFont(ofSize: 16)
        userNameLabel.textColor = .black
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        view.addSubview(userNameLabel);
        
        tableLabel.text = "Other Name Suggestions"
        tableLabel.textAlignment = .center
        tableLabel.font = UIFont.boldSystemFont(ofSize: 20)
        tableLabel.textColor = .black
        tableLabel.translatesAutoresizingMaskIntoConstraints = false;

        view.addSubview(tableLabel)
        
        setupConstraints()
    }
    
    @objc func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupConstraints(){
        let padding:CGFloat = 8;
        let imagePadding:CGFloat = 40;
        let width:CGFloat = view.frame.width-imagePadding*4;
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ])
        NSLayoutConstraint.activate([
            petImageView.topAnchor.constraint(equalTo: view.topAnchor,constant: imagePadding),
            petImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            petImageView.heightAnchor.constraint(equalToConstant: width),
            petImageView.widthAnchor.constraint(equalToConstant: width),
            petImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:imagePadding),
            petImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:-imagePadding),
        ])
        NSLayoutConstraint.activate([
            petNameLabel.topAnchor.constraint(equalTo: petImageView.bottomAnchor,constant: padding),
            petNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            petNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
            petNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
        ])
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: petNameLabel.bottomAnchor,constant: padding),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
        ])
        NSLayoutConstraint.activate([
            tableLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 20),
        ])
        NSLayoutConstraint.activate([
            namesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            namesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            namesTableView.topAnchor.constraint(equalTo: tableLabel.bottomAnchor,constant: 10),
            namesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
extension PetViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NamesTableViewCell {
            let name = names[indexPath.row]
            cell.configure(name: name)
            cell.selectionStyle = .none
            
            return cell
        } else {
            return UITableViewCell()
        }
    }

}

extension PetViewController: UITableViewDelegate {
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

