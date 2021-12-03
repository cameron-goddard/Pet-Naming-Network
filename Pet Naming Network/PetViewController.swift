//
//  PetViewController.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 11/21/21.
//

import UIKit

class PetViewController: UIViewController {

    private var petImageView:UIImageView = UIImageView()
    private var petNameLabel:UILabel = UILabel()
    private var userNameLabel:UILabel = UILabel()
    private var votesLabel = UILabel()
    private var closeButton = UIButton(type: .close)
    private var tableLabel:UILabel = UILabel()
    private var backgroundImageView = UIImageView()
    private var namesTableView:UITableView = UITableView()
    private var reuseIdentifier = "namesCellReuse"
    

    var votes:[Int] = [];
    let cellHeight:CGFloat = 50;
    
    var names:[String] = []
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
        view.backgroundColor = .secondarySystemBackground
        
        for x in 0...pet.nameSuggestions.count-1{
            names.append(pet.nameSuggestions[x])
            votes.append(x)
        }
        
        namesTableView.layer.cornerRadius = 10
        
        namesTableView.translatesAutoresizingMaskIntoConstraints = false
        namesTableView.dataSource = self
        namesTableView.delegate = self
        namesTableView.register(NamesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        namesTableView.isScrollEnabled = true
        namesTableView.showsVerticalScrollIndicator = true
        view.addSubview(namesTableView)
        namesTableView.reloadData()
        
        backgroundImageView.image = pet.petImage
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //blurEffectView.frame = contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
        view.addSubview(backgroundImageView)
        
        petImageView.contentMode = .scaleToFill
        petImageView.image = pet.petImage
        petImageView.layer.masksToBounds = true
        petImageView.layer.cornerRadius = 10
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        petImageView.dropShadow()
        backgroundImageView.addSubview(petImageView)
        
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.addSubview(closeButton)
        
        petNameLabel.text = pet.petName
        petNameLabel.textAlignment = .center
        petNameLabel.font = UIFont.boldSystemFont(ofSize: 36)
        petNameLabel.textColor = .white
        petNameLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.addSubview(petNameLabel)
    
        let submitText = "Submitted by: "
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]
        let submitAttrString = NSMutableAttributedString(string: submitText, attributes:attrs)
        let user = NSMutableAttributedString(string:pet.user)
        submitAttrString.append(user)
        userNameLabel.attributedText = submitAttrString
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        
        let votesText = "Votes: "
        let votesAttrString = NSMutableAttributedString(string: votesText, attributes:attrs)
        let votes = NSMutableAttributedString(string:"test")
        votesAttrString.append(votes)
        votesLabel.attributedText = votesAttrString
        votesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(votesLabel)
        
        tableLabel.text = "Other Name Suggestions"
        tableLabel.font = UIFont.boldSystemFont(ofSize: 20)
        tableLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableLabel)
        
        setupConstraints()
    }
    
    @objc func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupConstraints(){
        let padding:CGFloat = 8;
        let imagePadding:CGFloat = 20;
        let width:CGFloat = view.frame.width-imagePadding*4;
        
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: view.frame.size.height/2.7),
        ])
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 15),
            closeButton.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 15)
        ])
        NSLayoutConstraint.activate([
            petImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor,constant: 40),
            petImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            petImageView.widthAnchor.constraint(equalToConstant: 200),
            petImageView.heightAnchor.constraint(equalToConstant: 200),
            //petImageView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor,constant:imagePadding),
            //petImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor,constant:-imagePadding),
        ])
        NSLayoutConstraint.activate([
            petNameLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor,constant: -10),
            //petNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            petNameLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 20),
            //petNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
        ])
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor,constant: 20),
            //userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
        ])
        NSLayoutConstraint.activate([
            votesLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 10),
            votesLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            tableLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableLabel.topAnchor.constraint(equalTo: votesLabel.bottomAnchor,constant: 40),
        ])
        NSLayoutConstraint.activate([
            //namesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            //namesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            namesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            namesTableView.widthAnchor.constraint(equalToConstant: view.frame.width-40),
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
            let vote = votes[indexPath.row]
            cell.configure(name: name,votes: vote)
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

