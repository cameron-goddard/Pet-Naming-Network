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
    private var dateLabel = UILabel()
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
        backgroundImageView.dropShadow()
        view.addSubview(backgroundImageView)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //blurEffectView.frame = contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
        
        petImageView.contentMode = .scaleToFill
        petImageView.layer.cornerRadius = 10
        petImageView.layer.masksToBounds = true
        petImageView.image = pet.petImage
        petImageView.translatesAutoresizingMaskIntoConstraints = false
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
        
        let imageOffsetY: CGFloat = -5.0
        
        let personImageAttachment = NSTextAttachment()
        let personImage = UIImage(systemName: "person.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))!.withTintColor(.systemBlue)
        personImageAttachment.image = personImage
        personImageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: personImageAttachment.image!.size.width, height: personImageAttachment.image!.size.height)
        var attachmentString = NSAttributedString(attachment: personImageAttachment)
        var completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        var textAfterIcon = NSAttributedString(string: " " + pet.user, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
        completeText.append(textAfterIcon)
        
        userNameLabel.attributedText = completeText
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        
        
        let voteImageAttachment = NSTextAttachment()
        let thumbsUpImage = UIImage(systemName: "hand.thumbsup.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))!.withTintColor(.systemBlue)
        voteImageAttachment.image = thumbsUpImage
        voteImageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: voteImageAttachment.image!.size.width, height: voteImageAttachment.image!.size.height)
        attachmentString = NSAttributedString(attachment: voteImageAttachment)
        completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        textAfterIcon = NSAttributedString(string: " 16", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
        completeText.append(textAfterIcon)
        
        votesLabel.attributedText = completeText
        votesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(votesLabel)
        
        let dateImageAttachment = NSTextAttachment()
        let calendarImage = UIImage(systemName: "calendar.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))!.withTintColor(.systemBlue)
        dateImageAttachment.image = calendarImage
        dateImageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: dateImageAttachment.image!.size.width, height: dateImageAttachment.image!.size.height)
        attachmentString = NSAttributedString(attachment: dateImageAttachment)
        completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        textAfterIcon = NSAttributedString(string: " Date", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
        completeText.append(textAfterIcon)
        
        dateLabel.attributedText = completeText
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        
        
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
            petImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        NSLayoutConstraint.activate([
            petNameLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor,constant: -10),
            petNameLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 30),
        ])
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor,constant: 20),
            //userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
        ])
        NSLayoutConstraint.activate([
            votesLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 10),
            votesLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: votesLabel.bottomAnchor,constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: votesLabel.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            tableLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor,constant: 40),
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

