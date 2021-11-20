//
//  HeaderView.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 11/20/21.
//

import UIKit

class HeaderView: UICollectionReusableView {

    var headerLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textColor = .gray
        headerLabel.text = ""
        addSubview(headerLabel)

        setupConstraints()
    }

    func configure(for section: String) {
        headerLabel.text = section
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

}

