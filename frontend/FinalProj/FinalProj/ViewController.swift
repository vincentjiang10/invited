//
//  ViewController.swift
//  finalproj
//
//  Created by Big Mac on 4/26/23.
//

import UIKit

class ViewController: UIViewController {
    
    var events: [Event] = []

    let tableView = UITableView()
    let reuseID = "my cell"
    var currentIndex = IndexPath()
    var profileButton = UIBarButtonItem()
    var addEventButton = UIBarButtonItem()
    var filterCollectionView: UICollectionView!
    
    private var filters = ["Sports", "Food", "Party", "Social", "Other 😳"]
    
    let itemPadding: CGFloat = 10
    let distPadding: CGFloat = 50
    let sectionPadding: CGFloat = 5
    let filterHeight: CGFloat = 100
    let cellReuseID = "cellReuseID"
    let headerReuseID = "headerReuseID"
    let filtercellReuseID = "filterReuseID"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Event Feed"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.setNavigationBarHidden(false, animated: true)

        view.backgroundColor = .white
        
        events = [(Event(eventName: "Picnic", eventDate: "01/01/23", eventDescription: "Picnic with everyone!"))]
        
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
    
    @objc func pushView() {
        navigationController?.pushViewController(ProfileViewController(inputDelegate: self), animated: true)
    }
    
    @objc func popView() {
        print("unimplemented")
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
        

extension ViewController: updateCell {
    func updates(eventName: String, eventDate: String) {
        events[currentIndex.row].eventName = eventName
        events[currentIndex.row].eventDate = eventDate
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentIndex = indexPath
        let currentEvent = events[indexPath.row]
        
        let vc = EventDetailViewController(event: currentEvent)
        vc.del = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
    Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? EventTableViewCell {
            
            let currentEvent = events[indexPath.row]
            
            cell.updateFrom(event: currentEvent)
            
            
            return cell
            
        } else {
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            events.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
}

extension ViewController: ChangeTextDelegate {
    func changeText(nametext: String, emailtext: String) {
        title = nametext + "'s Event Feed"
        
    }
}

