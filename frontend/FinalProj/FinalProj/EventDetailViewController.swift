//
//  EventDetailViewController.swift
//  finalproj
//
//  Created by Big Mac on 4/26/23.
//

import UIKit

class EventDetailViewController: UIViewController {

    let eventName = UILabel()
    let eventDate = UILabel()
    var back = UIBarButtonItem()
    
    weak var del: updateCell?
    
    let event: Event

    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        title = "Event Details"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.setNavigationBarHidden(false, animated: true)

        back = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = back
        
        eventName.text = "Event"
        eventName.textColor = .black
        eventName.font = UIFont.boldSystemFont(ofSize: 15)
        eventName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventName)

        eventDate.text = "Date"
        eventDate.textColor = .black
        eventDate.font = UIFont.boldSystemFont(ofSize: 15)
        eventDate.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventDate)
        

        setupConstraints()
        
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            eventName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventName.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            eventName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            eventDate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventDate.topAnchor.constraint(equalTo: eventName.bottomAnchor, constant: 52),
            eventDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

}

protocol updateCell: UIViewController {
    func updates(eventName: String, eventDate: String)
}
