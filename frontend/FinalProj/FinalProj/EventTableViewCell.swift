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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
    
        eventName.translatesAutoresizingMaskIntoConstraints = false
        eventName.font = UIFont.systemFont(ofSize: 15)
        eventName.textColor = .gray
        self.contentView.addSubview(eventName)
        
        eventDate.translatesAutoresizingMaskIntoConstraints = false
        eventDate.font = UIFont.systemFont(ofSize: 15)
        eventDate.textColor = .gray
        self.contentView.addSubview(eventDate)
        
        setUpConstraints()
        
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            eventName.leadingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 30),
            eventName.centerYAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            eventDate.leadingAnchor.constraint(equalTo: eventName.trailingAnchor, constant: 30),
            eventDate.centerYAnchor.constraint(equalTo: eventName.bottomAnchor, constant: 20)
        ])
        
    }
    
    func updateFrom(event: Event) {
        eventName.text = "Event: " + event.eventName
        eventDate.text = "Date: " + event.eventDate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
