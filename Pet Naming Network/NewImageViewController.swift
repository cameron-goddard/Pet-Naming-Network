//
//  NewImageViewController.swift
//  Pet Naming Network
//
//  Created by Cameron Goddard on 11/12/21.
//

import UIKit

class NewImageViewController: UIViewController {

    
    private var imagePicker: ImagePicker!
    
    private var newImageView:UIImageView = UIImageView();
    private var addImageButton:UIButton = UIButton();
    private var uploadImageButton:UIButton = UIButton();
    //private var addView:UIView = UIView();
    let padding:CGFloat = 20;
    let buttonSize:CGFloat = 120;
    init(){
        
        super .init(nibName: nil, bundle: nil)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Image"
        view.backgroundColor = .systemBackground
       
        
       
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.setTitle("+", for: .normal)
        addImageButton.setTitleColor(.black, for: .normal)
        addImageButton.backgroundColor = .clear
        addImageButton.layer.borderColor = UIColor.systemGray.cgColor
        addImageButton.layer.borderWidth = 1
        addImageButton.layer.cornerRadius = buttonSize/2
        addImageButton.layer.masksToBounds = true;
        addImageButton.titleLabel?.font = .boldSystemFont(ofSize: 50)
        addImageButton.titleLabel?.textColor = .white;
        addImageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
      //  addImageButton.setImage(UIImage(systemName: "plus.circle.fill"), for: UIControl.State.normal)
        
     
       // addImageButton.isHidden = true;
        
        newImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width-padding*2, height: view.frame.size.width-padding*2))
        newImageView.addDashedBorder()
        
        newImageView.backgroundColor = .systemGray4
        newImageView.translatesAutoresizingMaskIntoConstraints = false;
        newImageView.isUserInteractionEnabled = true;
        view.addSubview(newImageView)
        newImageView.addSubview(addImageButton)
    
//        addView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width-padding*2, height: view.frame.size.width-padding*2))
//        addView.addDashedBorder()
//
//        addView.backgroundColor = .systemGray3
//        addView.translatesAutoresizingMaskIntoConstraints = false;
//        view.addSubview(addView)
//        addView.addSubview(addImageButton)
        
        
        setupConstraints()
    }
    
    func  setupConstraints(){
       // let width = view.frame.width;
//        NSLayoutConstraint.activate([
//            addView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: padding*2),
//            addView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            addView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
//            addView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
//            addView.heightAnchor.constraint(equalToConstant: view.frame.size.width-padding*2),
//            addView.widthAnchor.constraint(equalToConstant: view.frame.size.width-padding*2),
//        ])
        NSLayoutConstraint.activate([
            newImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: padding*2),
            newImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
            newImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
            newImageView.heightAnchor.constraint(equalToConstant: view.frame.size.width-padding*2),
            newImageView.widthAnchor.constraint(equalToConstant: view.frame.size.width-padding*2),
        ])
        
        NSLayoutConstraint.activate([
            addImageButton.centerXAnchor.constraint(equalTo: newImageView.centerXAnchor),
            addImageButton.centerYAnchor.constraint(equalTo: newImageView.centerYAnchor),
            addImageButton.widthAnchor.constraint(equalToConstant: buttonSize),
            addImageButton.heightAnchor.constraint(equalToConstant: buttonSize),
        ])
        
//        NSLayoutConstraint.activate([
//            newImageView.topAnchor.constraint(equalTo: addView.topAnchor),
//            newImageView.bottomAnchor.constraint(equalTo: addView.bottomAnchor),
//            newImageView.trailingAnchor.constraint(equalTo: addView.trailingAnchor),
//            newImageView.leadingAnchor.constraint(equalTo: addView.leadingAnchor)
//        ])
        
    }
    
    @objc func addImage(_ sender: UIButton){
        sender.startAnimatingPressActions()
        print("CLICK!!")
       self.imagePicker.present(from: sender)
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
extension NewImageViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.addImageButton.isHidden = true;
        let img:UIImage = image ?? UIImage()
        self.newImageView.image = cropToBounds(image: img, width: img.size.width, height: img.size.height);
        
    }
}
extension UIView {
    func addDashedBorder() {
        let color = UIColor.systemGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}
extension UIButton {
    
    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
            }, completion: nil)
    }
    
}
