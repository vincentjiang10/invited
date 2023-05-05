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
    var createdEvents: [Event] = []
    var invitedEvents: [Event] = []
    var searchedEvents: [Event] = []
    var filterActive = false
    var searchActive = false
    var activeFilterName: String?
    
    var filterCollectionView: UICollectionView!
    
    let reuseID = "my cell"
    var currentIndex = IndexPath()
    var profileButton = UIBarButtonItem()
    var addEventButton = UIBarButtonItem()
    
    let refreshControl = UIRefreshControl()
    
    var filters: [String] = ["Public", "Invited", "Created"]
    
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
        searchController.searchResultsUpdater = self
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search through Events"
        definesPresentationContext = true
        
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
    // Filtering -_-
    func filter() {
        if filterActive {
            if activeFilterName == "Public" {
                refreshData()
                filteredEvents = eventData
                eventData = filteredEvents
            } else if activeFilterName == "Invited" {
                invitedEvents = []
                eventData = invitedEvents
            } else if activeFilterName == "Created" {
                eventData = createdEvents
            }
        } else {
            refreshData()
        }
    }
    // Functions to push new VCs to user >w<
    @objc func pushProfileView() {
        navigationController?.pushViewController(ProfileViewController(inputDelegate: self), animated: true)
    }
    
    @objc func pushMakeEventView() {
        navigationController?.pushViewController(EventMakerViewController(inputDelegate: self), animated: true)
    }
}

extension ViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        if filterActive {
            if activeFilterName == "Created" {
                if !searchText.isEmpty {
                    searchActive = true
                    searchedEvents.removeAll()
                    for event in createdEvents {
                        if event.name.lowercased().contains(searchText.lowercased()) {
                            searchedEvents.append(event)
                        }
                    }
                    eventData = searchedEvents
                } else if searchText.isEmpty {
                    searchActive = false
                    searchedEvents.removeAll()
                    searchedEvents = createdEvents
                    eventData = searchedEvents
                }
            }
            else if activeFilterName == "Public" {
                if !searchText.isEmpty {
                    searchActive = true
                    searchedEvents.removeAll()
                    for event in filteredEvents {
                        if event.name.lowercased().contains(searchText.lowercased()) {
                            searchedEvents.append(event)
                        }
                    }
                    eventData = searchedEvents
                } else if searchText.isEmpty {
                    searchActive = false
                    searchedEvents.removeAll()
                    searchedEvents = eventData
                    eventData = searchedEvents
                }
            }
            else if activeFilterName == "Invited" {
                if !searchText.isEmpty {
                    searchActive = true
                    searchedEvents.removeAll()
                    searchedEvents = []
                } else if searchText.isEmpty {
                    searchActive = false
                    searchedEvents.removeAll()
                    searchedEvents = []
                    eventData = searchedEvents
                }
            }
        }
        else if !filterActive {
            if !searchText.isEmpty {
                searchActive = true
                searchedEvents.removeAll()
                for event in eventData {
                    if event.name.lowercased().contains(searchText.lowercased()) {
                        searchedEvents.append(event)
                    }
                }
            } else if searchText.isEmpty {
                searchActive = false
                searchedEvents.removeAll()
                searchedEvents = eventData
                eventData = searchedEvents
            }
        }
        else {
            searchActive = false
            searchedEvents.removeAll()
            searchedEvents = eventData
            eventData = searchedEvents
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchedEvents.removeAll()
        refreshData()
        tableView.reloadData()
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
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell {
            let newtext = cell.label.text!
            if filterActive {
                if activeFilterName == newtext {
                    cell.isSelected = false
                    activeFilterName = nil
                    filterActive = false
                    filter()
                    cell.label.backgroundColor = .systemMint
                    tableView.reloadData()
                } else {
                    let activeIndexPath = IndexPath(item: filters.firstIndex(of: activeFilterName!)!, section: 0)
                    if let activeCell = collectionView.cellForItem(at: activeIndexPath) as? FilterCollectionViewCell {
                        activeCell.isSelected = false
                        activeFilterName = newtext
                        filter()
                        activeCell.label.backgroundColor = .systemMint
                        cell.isSelected = true
                        cell.label.backgroundColor = .systemCyan
                        tableView.reloadData()
                    }
                }
            } else {
                cell.isSelected = true
                activeFilterName = newtext
                filterActive = true
                filter()
                cell.label.backgroundColor = .systemCyan
                tableView.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell {
            cell.isSelected = false
            filterActive = false
            activeFilterName = nil
            filter()
            tableView.reloadData()
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
        if filterActive && !searchActive {
            if activeFilterName == "Public" {
                let currentEvent = filteredEvents[indexPath.row]
                let vc = EventDetailViewController(event: currentEvent)
                navigationController?.pushViewController(vc, animated: true)
            } else if activeFilterName == "Invited" {
                print("No invites")
            } else if activeFilterName == "Created" {
                let currentEvent = createdEvents[indexPath.row]
                let vc = EventDetailViewController(event: currentEvent)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if searchActive {
            let currentEvent = searchedEvents[indexPath.row]
            let vc = EventDetailViewController(event: currentEvent)
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
                let currentEvent = eventData[indexPath.row]
                let vc = EventDetailViewController(event: currentEvent)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
        Int {
            if filterActive && !searchActive {
                if activeFilterName == "Public" {
                    return filteredEvents.count
                } else if activeFilterName == "Invited" {
                    return 0
                } else if activeFilterName == "Created" {
                    return createdEvents.count
                }
                
            } else if searchActive {
                return searchedEvents.count
            }
            return eventData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! EventTableViewCell
            if filterActive && !searchActive {
                if activeFilterName == "Public" {
                    let currentEvent = filteredEvents[indexPath.row]
                    cell.configure(eventObject: currentEvent)
                } else if activeFilterName == "Created" && createdEvents.count != 0 {
                    let currentEvent = createdEvents[indexPath.row]
                    cell.configure(eventObject: currentEvent)
                }
            } else if searchActive {
                let currentEvent = searchedEvents[indexPath.row]
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
        createdEvents.append(Event(id: 0, name: nametext, start_time: starttime, end_time: endtime, location: loc, access: acc, description: descrip))
    }
}
