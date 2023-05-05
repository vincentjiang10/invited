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
    var filteredEvents: [Event] = []
    var filterActive = false
    
    var filterCollectionView: UICollectionView!

    let reuseID = "my cell"
    var currentIndex = IndexPath()
    var profileButton = UIBarButtonItem()
    var addEventButton = UIBarButtonItem()
    
    let refreshControl = UIRefreshControl()
    
    var filters: [String] = ["Public", "Invited", "Created"]
    var newfilters: [String] = []
    
    let itemPadding: CGFloat = 10
    let distPadding: CGFloat = 50
    let sectionPadding: CGFloat = 5
    let filterHeight: CGFloat = 100
    let cellReuseID = "cellReuseID"
    let headerReuseID = "headerReuseID"
    let filtercellReuseID = "filterReuseID"
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        
        var url = URL(string: "http://35.238.52.218/api/events/public/to/users/")!
        let formatParameter = URLQueryItem(name: "format", value: "json")
        url.append(queryItems: [formatParameter])
        
        super.viewDidLoad()
        title = "Event Feed"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        
        view.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: reuseID)
        self.view.addSubview(tableView)
        
        profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: #selector(pushProfileView))
        navigationItem.leftBarButtonItem = profileButton
        
        addEventButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushMakeEventView))
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
            filterCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -4),
            filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: collectionViewPadding),
            filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -collectionViewPadding),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 70)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: collectionViewPadding),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
    }
    func bringEventData() {
        NetworkManager.shared.getAllEvents { events in
            DispatchQueue.main.async {
                self.eventData = events
                self.tableView.reloadData()
            }
        }
        
    }
    
    func filter(filter: String) {
        if filterActive {
            if filter == "Public" {
                for event in eventData {
                    if event.access == "Public" {
                        filteredEvents.append(event)
                    }
                }
            } else if filter == "Invited" {
                for event in eventData {
                    if event.name == "Slug Club" {
                        filteredEvents.append(event)
                    }
                }
            } else if filter == "Created" {
                for event in eventData {
                    if event.name == "Slug Club" {
                        filteredEvents.append(event)
                    }
                }
            }
        } else {
            filteredEvents = eventData
        }
    }

    @objc func refreshData() {
        NetworkManager.shared.getAllEvents { events in
            DispatchQueue.main.async {
                self.eventData = events
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        print(eventData.count)

    }
    
    @objc func pushProfileView() {
        navigationController?.pushViewController(ProfileViewController(inputDelegate: self), animated: true)
    }
    
    @objc func pushMakeEventView() {
        navigationController?.pushViewController(EventMakerViewController(inputDelegate: self), animated: true)
    }
    
}
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
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
            if filterActive {
                cell.isSelected = false
                filterActive = false
                cell.label.backgroundColor = .systemMint
            } else {
                cell.isSelected = true
                filterActive = true
                cell.label.backgroundColor = .systemCyan
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell{
            cell.isSelected = false
            filterActive = false
            cell.label.backgroundColor = .systemMint
            
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
        if filterActive {
            // filteredEvents.count
            return eventData.count
        } else {
            return eventData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! EventTableViewCell
        if filterActive {
            // filteredEvents[indexPath.row]
            let currentEvent = eventData[indexPath.row]
            cell.configure(eventObject: currentEvent)
        }
        else {
            let currentEvent = eventData[indexPath.row]
            cell.configure(eventObject: currentEvent)
        }
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
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
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
