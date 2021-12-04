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
    private var skipButton = UIButton()
    let userName = "test"
    
    private var votableNames : [Pet] = [Pet(petName: "Doggo", user: "test", petImageURL: "doggo", petState: .FEATURED),Pet(petName: "???", user: "test", petImageURL: "nice", petState: .FEATURED),Pet(petName: "Gamer", user: "test", petImageURL: "gamer", petState: .FEATURED),Pet(petName: "cat", user: "test", petImageURL: "waffle", petState: .FEATURED),Pet(petName: "cat", user: "test", petImageURL: "waffle", petState: .FEATURED)]
    
    private let reuseIdentifier = "votableNameCellReuse"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = .secondarySystemBackground
        view.backgroundColor = .secondarySystemBackground
        
        
        namesTableView.tableHeaderView = UIView()
        namesTableView.alwaysBounceVertical = false
        namesTableView.layer.cornerRadius = 10
        namesTableView.delegate = self
        namesTableView.dataSource = self
        namesTableView.register(VotableNameTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        namesTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(namesTableView)
        
        
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        skipButton.configuration = .filled()
        
        skipButton.configuration?.buttonSize = .large
        skipButton.setTitle("Skip", for: .normal)
        skipButton.tag = -1
        skipButton.addTarget(self, action: #selector(newImage(_:)), for: .touchUpInside)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(skipButton)
        
        setUpConstraints()
    }
    
    @objc func newImage(_ sender: UIButton) {
        if sender.tag != -1 {
            
        }
        
        UIView.transition(with: imageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.imageView.image = UIImage(systemName: "bolt.ring.closed")
        
        }, completion: nil)
        UIView.transition(with: namesTableView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.votableNames = [Pet(petName: "Doggo", user: "test", petImageURL: "doggo", petState: .FEATURED),Pet(petName: "???", user: "test", petImageURL: "nice", petState: .FEATURED),Pet(petName: "Gamer", user: "test", petImageURL: "gamer", petState: .FEATURED),Pet(petName: "cat", user: "test", petImageURL: "waffle", petState: .FEATURED),Pet(petName: "cat", user: "test", petImageURL: "waffle", petState: .FEATURED)]
            self.namesTableView.reloadData()
        }, completion: nil)
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
            namesTableView.widthAnchor.constraint(equalToConstant: view.frame.width-40),
            namesTableView.heightAnchor.constraint(equalToConstant: CGFloat(votableNames.count*60))
        ])
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: namesTableView.bottomAnchor, constant: 20),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: view.frame.width-40)
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
            cell.voteButton.addTarget(self, action: #selector(newImage(_:)), for: .touchUpInside)
            cell.voteButton.tag = indexPath.row
            cell.dislikeButton.addTarget(self, action: #selector(hideName(_:)), for: .touchUpInside)
            cell.dislikeButton.tag = indexPath.row
            let pet = votableNames[indexPath.row]
            cell.configure(name: pet.petName)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func hideName(_ sender: UIButton) {
        votableNames.remove(at: sender.tag)
        namesTableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .fade)
        namesTableView.reloadData()
        //setUpConstraints()
    }
}


extension VoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = votableNames[indexPath.row]
        //let vc = SongViewController(delegate: self, song: song, index: indexPath.row)
        //navigationController?.pushViewController(vc, animated: true)
    }
}
