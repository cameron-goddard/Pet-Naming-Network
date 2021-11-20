//
//  PetCollectionViewCell.swift
//  Pet Naming Network
//
//  Created by Marco Palomino on 11/20/21.
//

import UIKit
import SnapKit

class PetCollectionViewCell: UICollectionViewCell {
    
    private var petImageView = UIImageView()
    private var petNameLabel = UILabel();
    private var userNameLabel = UILabel();
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemGray6

        petImageView.contentMode = .scaleAspectFit
        contentView.addSubview(petImageView)
        
        petNameLabel.textAlignment = .center
        petNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        petNameLabel.textColor = .orange
        contentView.addSubview(petNameLabel);
        userNameLabel.textAlignment = .center
        userNameLabel.font = .systemFont(ofSize: 12)
        userNameLabel.textColor = .black
        contentView.addSubview(userNameLabel);
        
        setupConstraints();
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for pet:Pet){
        petNameLabel.text = pet.petName;
        petImageView.image = cropToBounds(image: pet.petImage, width: pet.petImage.size.width, height: pet.petImage.size.height);
        userNameLabel.text = "By:\(pet.userUploaded)"
    }
    
    func setupConstraints(){
        let padding:CGFloat = 6;
        let width = contentView.frame.width
        petImageView.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(padding)
        }
        petImageView.snp.makeConstraints{make in
            make.height.width.equalTo(width);
        }
        petNameLabel.snp.makeConstraints{make in
            make.top.equalTo(petImageView.snp.bottom).offset(padding);
        }
        petNameLabel.snp.makeConstraints{make in
            make.trailing.leading.equalToSuperview()
        }
        userNameLabel.snp.makeConstraints{make in
            make.top.equalTo(petNameLabel.snp.bottom).offset(padding);
        }
        userNameLabel.snp.makeConstraints{make in
            make.trailing.leading.equalToSuperview()
        }
        
    }
    private func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
            let cgimage = image.cgImage!
            let contextImage: UIImage = UIImage(cgImage: cgimage)
            let contextSize: CGSize = contextImage.size
            var posX: CGFloat = 0.0
            var posY: CGFloat = 0.0
            var cgwidth: CGFloat = CGFloat(width)
            var cgheight: CGFloat = CGFloat(height)

            // See what size is longer and create the center off of that
            if contextSize.width > contextSize.height {
                posX = ((contextSize.width - contextSize.height) / 2)
                posY = 0
                cgwidth = contextSize.height
                cgheight = contextSize.height
            } else {
                posX = 0
                posY = ((contextSize.height - contextSize.width) / 2)
                cgwidth = contextSize.width
                cgheight = contextSize.width
            }

            let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

            // Create bitmap image from context using the rect
            let imageRef: CGImage = cgimage.cropping(to: rect)!

            // Create a new image based on the imageRef and rotate back to the original orientation
            let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

            return image
        }
}
