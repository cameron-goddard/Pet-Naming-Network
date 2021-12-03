//
//  VoteViewController.swift
//  Pet Naming Network
//
//  Created by Cameron Goddard on 12/2/21.
//

import UIKit

class VoteViewController: UIViewController {

    private var imageView = UIImageView()
    private var namesTableView = UITableView()
    let userName = "test"
    
    private var votableNames : [Pet] = [Pet(petName: "Doggo", user: "test", petImageURL: "doggo", petState: .Featured),Pet(petName: "???", user: "test", petImageURL: "nice", petState: .Featured),Pet(petName: "Gamer", user: "test", petImageURL: "gamer", petState: .Featured),Pet(petName: "cat", user: "test", petImageURL: "waffle", petState: .Featured),Pet(petName: "cat", user: "test", petImageURL: "waffle", petState: .Featured),Pet(petName: "cat", user: "test", petImageURL: "waffle", petState: .Featured),Pet(petName: "cat", user: "test", petImageURL: "waffle", petState: .Featured)]
    
    private let reuseIdentifier = "votableNameCellReuse"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        namesTableView.layer.cornerRadius = 10
        namesTableView.delegate = self
        namesTableView.dataSource = self
        namesTableView.register(VotableNameTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        namesTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(namesTableView)
        
        
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            namesTableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            namesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            namesTableView.widthAnchor.constraint(equalToConstant: view.frame.width-20),
            namesTableView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VoteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return votableNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? VotableNameTableViewCell {
            
            let pet = votableNames[indexPath.row]
            cell.configure(name: pet.petName)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}


extension VoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = votableNames[indexPath.row]
        //let vc = SongViewController(delegate: self, song: song, index: indexPath.row)
        //navigationController?.pushViewController(vc, animated: true)
    }
}
