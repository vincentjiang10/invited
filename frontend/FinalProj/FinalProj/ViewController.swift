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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Event Feed"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.backgroundColor = UIColor.black
        navigationController?.setNavigationBarHidden(false, animated: true)

        view.backgroundColor = .white
        
        events = [(Event(eventName: "Picnic", eventDate: "01/01/23"))]
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: reuseID)
        self.view.addSubview(tableView)
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        //TODO: Setup constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
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
