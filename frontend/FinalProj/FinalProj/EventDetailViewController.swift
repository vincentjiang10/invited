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
    let eventLoc = UILabel()
    let eventActualLoc = UILabel()
    let eventAcc = UILabel()
    let eventDescrip = UILabel()
    let eventActualDescrip = UILabel()
    var back = UIBarButtonItem()
    
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
        navigationItem.largeTitleDisplayMode = .never

        back = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = back
        
        eventName.text = "Event:"
        eventName.textColor = .gray
        eventName.font = UIFont.boldSystemFont(ofSize: 24)
        eventName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventName)

        eventActualName.text = event.name
        eventActualName.textColor = .black
        
        let PalatinoFont = UIFontDescriptor(name: "Palatino", size: 30.0)
        let boldFontDescriptor = PalatinoFont.withSymbolicTraits(.traitBold)
        let boldFont = UIFont(descriptor: boldFontDescriptor!, size: 35.0)
        
        eventActualName.font = boldFont
        eventActualName.translatesAutoresizingMaskIntoConstraints = false
        eventActualName.numberOfLines = 0
        eventActualName.lineBreakMode = .byWordWrapping
        eventActualName.sizeToFit()
        view.addSubview(eventActualName)
        
        eventDate.text = "Date:"
        eventDate.textColor = .gray
        eventDate.font = UIFont.boldSystemFont(ofSize: 24)
        eventDate.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventDate)
        
        eventActualDate.text = event.start_time + " - " + event.end_time
        eventActualDate.textColor = .black
        
        let ArialFont = UIFontDescriptor(name: "Arial", size: 22.0)
        let boldFontDescriptorDuplie = ArialFont.withSymbolicTraits(.traitBold)
        let boldFontDuplie = UIFont(descriptor: boldFontDescriptorDuplie!, size: 22.0)
        
        eventActualDate.font = boldFontDuplie
        eventActualDate.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventActualDate)
        
        eventLoc.text = "Location:"
        eventLoc.textColor = .gray
        eventLoc.font = UIFont.boldSystemFont(ofSize: 24)
        eventLoc.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventLoc)
        
        eventActualLoc.text = event.location
        eventActualDate.textColor = .black
        
        let ArialFont2 = UIFontDescriptor(name: "Arial", size: 22.0)
        let boldFontDescriptorDuplie2 = ArialFont2.withSymbolicTraits(.traitBold)
        let boldFontDuplie2 = UIFont(descriptor: boldFontDescriptorDuplie2!, size: 22.0)
        
        eventActualLoc.font = boldFontDuplie2
        eventActualLoc.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventActualLoc)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.red,
        ]
        
        let attributesother: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
        ]
        
        let attributedStringofEventAcc = NSAttributedString(string: event.access.lowercased(), attributes: attributes)
        
        
        
        let combinedString = NSMutableAttributedString()
        let beginString = NSAttributedString(string: "This is a ", attributes: attributesother)
        let endString = NSAttributedString(string: " event.", attributes: attributesother)

        combinedString.append(beginString)
        combinedString.append(attributedStringofEventAcc)
        combinedString.append(endString)

        eventAcc.attributedText = combinedString
        eventAcc.font = UIFont.boldSystemFont(ofSize: 24)
        eventAcc.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventAcc)
        
        eventDescrip.text = "Description"
        eventDescrip.textColor = .gray
        eventDescrip.font = UIFont.boldSystemFont(ofSize: 24)
        eventDescrip.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventDescrip)
        
        eventActualDescrip.text = event.description
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
            eventAcc.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventAcc.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            eventAcc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            eventName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventName.topAnchor.constraint(equalTo: eventAcc.bottomAnchor, constant: 15),
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
            eventLoc.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventLoc.topAnchor.constraint(equalTo: eventActualDate.bottomAnchor, constant: 15),
            eventLoc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            eventActualLoc.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventActualLoc.topAnchor.constraint(equalTo: eventLoc.bottomAnchor, constant: 5),
            eventActualLoc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventActualLoc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            eventDescrip.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventDescrip.topAnchor.constraint(equalTo: eventActualLoc.bottomAnchor, constant: 52),
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
