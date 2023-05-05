//
//  EventTableViewCell.swift
//  finalproj
//
//  Created by Big Mac on 4/26/23.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    let eventName = UILabel()
    let eventDate = UILabel()
    let eventAcc = UILabel()
    let eventDescrip = UILabel()
    let eventDescripTitle = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
    
        eventName.translatesAutoresizingMaskIntoConstraints = false
        eventName.font = UIFont.boldSystemFont(ofSize: 24)
        eventName.textColor = .black
        self.contentView.addSubview(eventName)
        
        eventDate.translatesAutoresizingMaskIntoConstraints = false
        eventDate.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        eventDate.textColor = .black
        self.contentView.addSubview(eventDate)
        
        eventAcc.translatesAutoresizingMaskIntoConstraints = false
        eventAcc.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        eventAcc.textColor = .red
        self.contentView.addSubview(eventAcc)
        
        eventDescrip.translatesAutoresizingMaskIntoConstraints = false
        eventDescrip.font = UIFont.systemFont(ofSize: 15)
        eventDescrip.textColor = .black
        self.contentView.addSubview(eventDescrip)
        
        eventDescripTitle.translatesAutoresizingMaskIntoConstraints = false
        eventDescripTitle.font = UIFont.italicSystemFont(ofSize: 15)
        eventDescripTitle.textColor = .black
        eventDescripTitle.text = "Description:"
        self.contentView.addSubview(eventDescripTitle)
        
        
        setUpConstraints()
        
    }
    
    func setUpConstraints() {

        NSLayoutConstraint.activate([
            eventAcc.leadingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -90),
            eventAcc.centerYAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            eventAcc.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            eventName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30),
            eventName.centerYAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            eventName.trailingAnchor.constraint(equalTo: eventAcc.leadingAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            eventDate.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30),
            eventDate.centerYAnchor.constraint(equalTo: eventName.bottomAnchor, constant: 12)
        ])

        NSLayoutConstraint.activate([
            eventDescripTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30),
            eventDescripTitle.centerYAnchor.constraint(equalTo: eventDate.bottomAnchor, constant: 12),
            eventDescripTitle.trailingAnchor.constraint(equalTo: eventAcc.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            eventDescrip.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30),
            eventDescrip.centerYAnchor.constraint(equalTo: eventDescripTitle.bottomAnchor, constant: 10),
            eventDescrip.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
        ])
    }
    
    func configure(eventObject: Event) {
        eventName.text = eventObject.name
        eventDate.text = eventObject.start_time + " - " + eventObject.end_time
        eventAcc.text = eventObject.access
        eventDescrip.text = eventObject.description
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
