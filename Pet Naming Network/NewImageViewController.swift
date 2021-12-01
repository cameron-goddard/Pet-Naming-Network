//
//  NewImageViewController.swift
//  Pet Naming Network
//
//  Created by Cameron Goddard on 11/12/21.
//

import UIKit

class NewImageViewController: UIViewController {

    
    private var imagePicker: ImagePicker!
    
    private var newImageView = UIImageView();
    private var addImageButton = UIButton();
    private var uploadImageButton = UIButton();
    private var addView = UIView();
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
        title = "Add New Image"
        view.backgroundColor = .systemBackground
        addView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width-padding*2, height: view.frame.size.width-padding*2))
        addView.addDashedBorder()
        addView.backgroundColor = .red
        addView.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(addView)
        
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.setTitleColor(.black, for: .normal)
        addImageButton.backgroundColor = .clear
        addImageButton.layer.borderColor = UIColor.white.cgColor
        addImageButton.layer.borderWidth = 1
        addImageButton.layer.cornerRadius = buttonSize/2
        addImageButton.layer.masksToBounds = true;
        addImageButton.titleLabel?.font = .boldSystemFont(ofSize: 50)
        addImageButton.titleLabel?.textColor = .white;
        addImageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        
        
        setupConstraints()
    }
    
    func  setupConstraints(){
       // let width = view.frame.width;
        NSLayoutConstraint.activate([
            addView.topAnchor.constraint(equalTo: view.topAnchor,constant: padding*3),
            addView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
    
    @objc func addImage(_ sender: UIButton){
        self.imagePicker.present(from: sender)
    }

}
extension NewImageViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.newImageView.image = image ?? UIImage();
        
    }
}
extension UIView {
    func addDashedBorder() {
        let color = UIColor.black.cgColor
        
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
