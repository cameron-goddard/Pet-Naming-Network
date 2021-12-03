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
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                alpha = 0.5
            } else {
                alpha = 1.0
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemGray6

        petImageView.contentMode = .scaleAspectFit
        
        
        petNameLabel.textAlignment = .center
        petNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        petNameLabel.textColor = .orange
       
        userNameLabel.textAlignment = .center
        userNameLabel.font = .systemFont(ofSize: 12)
        userNameLabel.textColor = .black
        
        contentView.addSubview(petNameLabel);
        contentView.addSubview(userNameLabel);
        contentView.addSubview(petImageView)
      
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for pet:Pet){
        petNameLabel.text = pet.petName;
        petImageView.image = cropToBounds(image: pet.petImage, width: pet.petImage.size.width, height: pet.petImage.size.height);
        userNameLabel.text = "By:\(pet.user)"
        let gradient = CAGradientLayer()

        gradient.frame = contentView.bounds
        gradient.colors = [UIColor.orange.cgColor,UIColor.yellow.cgColor,UIColor.white.cgColor,UIColor.yellow.cgColor]
        contentView.layer.insertSublayer(gradient, at: 0)
        setupConstraints();
    }
    
    func accountConfigure(for pet:Pet){
        petNameLabel.text = "";
        petImageView.image = cropToBounds(image: pet.petImage, width: pet.petImage.size.width, height: pet.petImage.size.height);
        userNameLabel.text = ""
        petImageView.layer.borderWidth = 2;
        petImageView.layer.borderColor = UIColor.systemBlue.cgColor
        let padding:CGFloat = 6;
        let width = contentView.frame.width-padding*2;
        petImageView.snp.makeConstraints{make in
            make.centerX.centerY.equalToSuperview();
            make.height.width.equalTo(width);
        }
    }
    
    func setupConstraints(){
        let padding:CGFloat = 6;
        let width = contentView.frame.width-padding*2;
        petImageView.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(padding)
            make.centerX.equalToSuperview();
            make.height.width.equalTo(width);
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
        petNameLabel.snp.makeConstraints{make in
            make.top.equalTo(petImageView.snp.bottom).offset(padding);
            make.trailing.leading.equalToSuperview()
        }
        userNameLabel.snp.makeConstraints{make in
            make.top.equalTo(petNameLabel.snp.bottom).offset(padding);
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
