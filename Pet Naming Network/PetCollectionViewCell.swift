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
    private var petNameLabel = UILabel()
    //private var userNameLabel = UILabel()
    private var backgroundImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        petImageView.contentMode = .scaleAspectFit
        petImageView.layer.masksToBounds = true
        petImageView.layer.cornerRadius = 10
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //petNameLabel.textAlignment = .center
        petNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        petNameLabel.translatesAutoresizingMaskIntoConstraints = false
       
        //userNameLabel.textAlignment = .center
        //userNameLabel.font = .systemFont(ofSize: 12)
        //userNameLabel.textColor = .black
        //userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(petNameLabel)
        contentView.addSubview(petImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for pet:Pet){
        petNameLabel.text = pet.petName.name;
        petImageView.image = cropToBounds(image: pet.petImage, width: pet.petImage.size.width, height: pet.petImage.size.height);
        //userNameLabel.text = "By: \(pet.user)"
        let gradient = CAGradientLayer()
        
        gradient.frame = contentView.bounds
        gradient.colors = [UIColor.orange.cgColor,UIColor.yellow.cgColor,UIColor.white.cgColor,UIColor.yellow.cgColor]
        
        let backgroundLayer = CALayer()
        backgroundLayer.frame = contentView.bounds
        backgroundLayer.contents = pet.petImage
        
        backgroundImageView.image = pet.petImage
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
        setupConstraints()
    }
    
    func accountConfigure(for pet:Pet){
        petNameLabel.text = "";
        petImageView.image = cropToBounds(image: pet.petImage, width: pet.petImage.size.width, height: pet.petImage.size.height);
        //userNameLabel.text = ""
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
        
        NSLayoutConstraint.activate([
            petImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            petImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            petImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            petImageView.heightAnchor.constraint(equalToConstant: width)
        ])
        
        /*petImageView.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(padding)
            make.centerX.equalToSuperview();
            make.height.width.equalTo(width);
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            
        }*/
        /*petNameLabel.snp.makeConstraints{make in
            make.top.equalTo(petImageView.snp.bottom).offset(padding);
            make.trailing.leading.equalToSuperview()
        }*/
        /*userNameLabel.snp.makeConstraints{make in
            make.top.equalTo(petNameLabel.snp.bottom).offset(padding);
            make.trailing.leading.equalToSuperview()
        }*/
        
        NSLayoutConstraint.activate([
            petNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            petNameLabel.topAnchor.constraint(equalTo: petImageView.bottomAnchor, constant: 5)
        ])
        /*NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            userNameLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor)
        ])*/
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
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
