//
//  EventDetailViewController.swift
//  finalproj
//
//  Created by Big Mac on 4/26/23.
//

import UIKit

class EventDetailViewController: UIViewController {

    let eventName = UILabel()
    let eventActualName = UILabel()
    let eventDate = UILabel()
    let eventActualDate = UILabel()
    let eventDescrip = UILabel()
    let eventActualDescrip = UILabel()
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
        
        eventName.text = "Event:"
        eventName.textColor = .gray
        eventName.font = UIFont.boldSystemFont(ofSize: 24)
        eventName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventName)

        eventActualName.text = event.eventName
        eventActualName.textColor = .black
        
        let PalatinoFont = UIFontDescriptor(name: "Palatino", size: 30.0)
        let boldFontDescriptor = PalatinoFont.withSymbolicTraits(.traitBold)
        let boldFont = UIFont(descriptor: boldFontDescriptor!, size: 35.0)
        
        eventActualName.font = boldFont
        eventActualName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventActualName)
        
        eventDate.text = "Date:"
        eventDate.textColor = .gray
        eventDate.font = UIFont.boldSystemFont(ofSize: 24)
        eventDate.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventDate)
        
        eventActualDate.text = event.eventDate
        eventActualDate.textColor = .black
        
        let ArialFont = UIFontDescriptor(name: "Arial", size: 22.0)
        let boldFontDescriptorDuplie = ArialFont.withSymbolicTraits(.traitBold)
        let boldFontDuplie = UIFont(descriptor: boldFontDescriptorDuplie!, size: 22.0)
        
        eventActualDate.font = boldFontDuplie
        eventActualDate.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventActualDate)
        
        eventDescrip.text = "Description"
        eventDescrip.textColor = .gray
        eventDescrip.font = UIFont.boldSystemFont(ofSize: 24)
        eventDescrip.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventDescrip)
        
        eventActualDescrip.text = event.eventDescription
        eventActualDescrip.textColor = .black
        
        let PalatinoFontDupe = UIFontDescriptor(name: "Palatino", size: 22.0)
        let boldFontDescriptorDupe = PalatinoFontDupe.withSymbolicTraits(.traitBold)
        let boldFontDupe = UIFont(descriptor: boldFontDescriptorDupe!, size: 22.0)
        
        eventActualDescrip.font = boldFontDupe
        eventActualDescrip.translatesAutoresizingMaskIntoConstraints = false
        eventActualDescrip.numberOfLines = 0
        eventActualDescrip.lineBreakMode = .byWordWrapping
        eventActualDescrip.sizeToFit()
        view.addSubview(eventActualDescrip)
        
        setupConstraints()
        
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            eventName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventName.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            eventName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            eventActualName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventActualName.topAnchor.constraint(equalTo: eventName.bottomAnchor, constant: 5),
            eventActualName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventActualName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            eventDate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventDate.topAnchor.constraint(equalTo: eventActualName.bottomAnchor, constant: 15),
            eventDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            eventActualDate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventActualDate.topAnchor.constraint(equalTo: eventDate.bottomAnchor, constant: 5),
            eventActualDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventActualDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            eventDescrip.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventDescrip.topAnchor.constraint(equalTo: eventActualDate.bottomAnchor, constant: 52),
            eventDescrip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        
        NSLayoutConstraint.activate([
            eventActualDescrip.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventActualDescrip.topAnchor.constraint(equalTo: eventDescrip.bottomAnchor, constant: 5),
            eventActualDescrip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventActualDescrip.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

}

protocol updateCell: UIViewController {
    func updates(eventName: String, eventDate: String, eventDescrip: String)
}
