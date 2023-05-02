//
//  ViewController.swift
//  finalproj
//
//  Created by Big Mac on 4/26/23.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    var eventData: [Event] = []
    var newevents: [Event] = []
    
    var filterCollectionView: UICollectionView!

    let reuseID = "my cell"
    var currentIndex = IndexPath()
    var profileButton = UIBarButtonItem()
    var addEventButton = UIBarButtonItem()
    
    let refreshControl = UIRefreshControl()
    
    var filters: [String] = ["Public", "Invited", "Personal"]
    var newfilters: [String] = []
    
    let itemPadding: CGFloat = 10
    let distPadding: CGFloat = 50
    let sectionPadding: CGFloat = 5
    let filterHeight: CGFloat = 100
    let cellReuseID = "cellReuseID"
    let headerReuseID = "headerReuseID"
    let filtercellReuseID = "filterReuseID"
    

    override func viewDidLoad() {
        
        var url = URL(string: "https://34.85.172.228/")!
        let formatParameter = URLQueryItem(name: "format", value: "json")
        url.append(queryItems: [formatParameter])
        
        super.viewDidLoad()
        title = "Event Feed"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.setNavigationBarHidden(false, animated: true)

        view.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: reuseID)
        self.view.addSubview(tableView)
        
        profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: #selector(pushView))
        navigationItem.leftBarButtonItem = profileButton
        
        addEventButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(popView))
        navigationItem.rightBarButtonItem = addEventButton
        
        let filterFlowLayout = UICollectionViewFlowLayout()
        filterFlowLayout.minimumLineSpacing = itemPadding
        filterFlowLayout.minimumInteritemSpacing = distPadding
        filterFlowLayout.scrollDirection = .horizontal
        filterFlowLayout.sectionInset = UIEdgeInsets(top: sectionPadding, left: sectionPadding, bottom: sectionPadding, right: sectionPadding)
        
        filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: filterFlowLayout)
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        filterCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "filterReuseID")
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        view.addSubview(filterCollectionView)
        
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        bringEventData()
        setupConstraints()
        
    }
    
    func setupConstraints() {
        let collectionViewPadding: CGFloat = 1
        
        NSLayoutConstraint.activate([
            filterCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: collectionViewPadding),
            filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -collectionViewPadding),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: collectionViewPadding),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
    }
    func bringEventData() {
//        NetworkManager.shared.getAllEvents { eventors in
//            DispatchQueue.main.async {
//                self.newevents = eventors
//                self.tableView.reloadData()
//            }
//        }
        
        newevents = [
            (Event(id: 0, name: "Picnic", start_time: "05/05/23", end_time: "05/06/23" , location: "Ho Plaza", access: "Public", description: "Picnic with everyone!")),
            (Event(id: 1, name: "Dance Party", start_time: "05/06/23", end_time: "05/06/23", location: "Willard", access: "Public", description: "Disco dance party in Willard.")),
            (Event(id: 2, name: "Basketball Game", start_time: "05/06/23", end_time: "05/07/23", location: "Gym", access: "Public", description: "Cornell v.s. Princeton. Come join and cheer on the team! Free shirts given too <3")),
            (Event(id: 3, name: "Movie hangout?", start_time: "05/07/23", end_time: "05/07/23", location: "Cornell Cinema", access: "Public", description: "Anyone want to watch a film with me?")),
            (Event(id: 4, name: "BBQ", start_time: "05/05/23", end_time: "05/09/23", location: "The Wilderness", access: "Public", description: "BBQ at the slope.")),
            (Event(id: 5, name: "New SZA Album Listening Party!!", start_time: "05/10/23", end_time: "05/12/23", location: "Barton Hall", access: "Public", description: "Vibe to the new SZA album at Goldwin. Skip Slope Day lol.")),
            (Event(id: 6, name: "Dyson Networking Hour", start_time: "05/15/23", end_time: "05/15/23", location: "Sage Hall", access: "Public", description: "Meet with fellow students and professors.")),
            (Event(id: 7, name: "Slug Club", start_time: "05/18/23", end_time: "05/19/23", location: "Hogwarts", access: "Public", description: "Social club for Professor Slughorn's favorite students!")),
            ]
        
    }

    @objc func refreshData() {
        NetworkManager.shared.getAllEvents { eventors in
            DispatchQueue.main.async {
                self.newevents = eventors
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }

    }
    
    @objc func pushView() {
        navigationController?.pushViewController(ProfileViewController(inputDelegate: self), animated: true)
    }
    
    @objc func popView() {
        present(EventMakerViewController(inputDelegate: self), animated: true)
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == self.filterCollectionView) {
            if let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: filtercellReuseID, for: indexPath) as? FilterCollectionViewCell {
                let filter = filters[indexPath.row]
                cell.configure(filterName: filter)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell{
            cell.label.backgroundColor = .systemCyan
            if cell.label.text == "Public Events" {
//                unimplemented need to implement filters
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width / 3.2)
        return CGSize(width: width, height: 50)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
}
        
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentIndex = indexPath
        let currentEvent = eventData[indexPath.row]
        
        let vc = EventDetailViewController(event: currentEvent)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
    Int {
        return eventData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! EventTableViewCell
        let currentEvent = newevents[indexPath.row]
        cell.configure(eventObject: currentEvent)
            
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: 0.5)
        topBorder.backgroundColor = UIColor.purple.cgColor
        cell.contentView.layer.addSublayer(topBorder)
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: cell.contentView.frame.height, width: cell.contentView.frame.width, height: 0.5)
        bottomBorder.backgroundColor = UIColor.purple.cgColor
        cell.contentView.layer.addSublayer(bottomBorder)
            
        return cell
        
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }    
}

extension ViewController: ChangeTextDelegate {
    func changeText(nametext: String, emailtext: String) {
        title = nametext + "'s Event Feed"
        
    }
}

extension ViewController: MakeEventDelegate {
    func createEvent(nametext: String, starttime: String, endtime: String, loc: String,  acc: String, descrip: String) {
        NetworkManager.shared.createEvent(nametext: nametext, starttime: starttime, endtime: endtime, loc: loc, acc: acc, descrip: descrip) { event in
            print("success")
        }
    }
}
