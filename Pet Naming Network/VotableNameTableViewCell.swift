//
//  VotableNameTableViewCell.swift
//  Pet Naming Network
//
//  Created by Cameron Goddard on 12/2/21.
//

import UIKit

class VotableNameTableViewCell: UITableViewCell {

    private var nameLabel = UILabel()
    var voteButton = UIButton()
    var dislikeButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.font = .systemFont(ofSize: 18)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        voteButton.configuration = .tinted()
        voteButton.setTitle("Vote", for: .normal)
        voteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(voteButton)
        
        dislikeButton.configuration = .tinted()
        dislikeButton.configuration?.baseBackgroundColor = .systemRed
        dislikeButton.configuration?.baseForegroundColor = .systemRed
        dislikeButton.configuration?.image = UIImage(systemName: "hand.thumbsdown")
        dislikeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dislikeButton)
        
        setUpConstraints()
    }
    
    func configure(name: String) {
        nameLabel.text = name
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            voteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            voteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            dislikeButton.trailingAnchor.constraint(equalTo: voteButton.leadingAnchor, constant: -10),
            dislikeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

