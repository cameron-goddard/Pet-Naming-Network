//
//  NamesTableViewCell.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 12/2/21.
//

import UIKit
import Alamofire

class NamesTableViewCell: UITableViewCell {

    var nameLabel = UILabel();

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear;
        
        
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = .black
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false;
        contentView.addSubview(nameLabel)
        
        setupConstraints();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(name:String) {
        nameLabel.text = name;
    }
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

        ])
        
    }
}
