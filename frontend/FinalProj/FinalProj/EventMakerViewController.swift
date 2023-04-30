//
//  EventMakerViewController.swift
//  finalproj
//
//  Created by Big Mac on 4/30/23.
//

import UIKit

class EventMakerViewController: UIViewController {

    let eventNameLabel = UILabel()
    let eventDateLabel = UILabel()
    let eventDescriptionLabel = UILabel()
    let titleof = UILabel()
    let eventNameField = UITextField()
    let eventDateField = UITextField()
    let eventDescriptionField = UITextField()
    var saveButton = UIButton()
    
    weak var delegate: MakeEventDelegate?
    
    init(inputDelegate: MakeEventDelegate) {
        delegate = inputDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        titleof.text = "Make an Event!"
        titleof.font = UIFont.boldSystemFont(ofSize: 24)
        titleof.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleof)
        
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.blue, for: .normal)
        saveButton.addTarget(self, action: #selector(savenew), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: eventNameField.frame.height))
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: eventNameField.frame.height))
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: eventNameField.frame.height))
        
        eventNameField.leftView = paddingView
        eventNameField.leftViewMode = .always
        eventDateField.leftView = paddingView1
        eventDateField.leftViewMode = .always
        eventDescriptionField.leftView = paddingView2
        eventDescriptionField.leftViewMode = .always
        
        eventNameField.placeholder = "Name of your Event!"
        eventNameField.textAlignment = .left
        eventNameField.backgroundColor = UIColor.white
        eventNameField.font = UIFont.systemFont(ofSize: 14)
        eventDateField.placeholder = "Add the Date!"
        eventDateField.textAlignment = .left
        eventDateField.backgroundColor = UIColor.white
        eventDateField.font = UIFont.systemFont(ofSize: 14)
        eventDescriptionField.placeholder = "Tell us more! Give us the Details!"
        eventDescriptionField.textAlignment = .left
        eventDescriptionField.backgroundColor = UIColor.white
        eventDescriptionField.font = UIFont.systemFont(ofSize: 14)
        
        eventNameField.borderStyle = .roundedRect
        eventNameField.layer.cornerRadius = 9
        eventNameField.layer.borderWidth = 1
        eventNameField.layer.backgroundColor = CGColor.init(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        eventNameField.layer.borderColor = UIColor.black.cgColor
        eventNameField.layer.cornerRadius = 5
        eventNameField.layer.borderColor = UIColor.gray.cgColor
        eventNameField.translatesAutoresizingMaskIntoConstraints = false
        eventDateField.borderStyle = .roundedRect
        eventDateField.layer.cornerRadius = 9
        eventDateField.layer.backgroundColor = CGColor.init(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        eventDateField.layer.borderWidth = 1
        eventDateField.layer.borderColor = UIColor.black.cgColor
        eventDateField.layer.cornerRadius = 5
        eventDateField.layer.borderColor = UIColor.gray.cgColor
        eventDateField.translatesAutoresizingMaskIntoConstraints = false
        eventDescriptionField.borderStyle = .roundedRect
        eventDescriptionField.layer.cornerRadius = 9
        eventDescriptionField.layer.backgroundColor = CGColor.init(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        eventDescriptionField.layer.borderWidth = 1
        eventDescriptionField.layer.borderColor = UIColor.black.cgColor
        eventDescriptionField.layer.cornerRadius = 5
        eventDescriptionField.layer.borderColor = UIColor.gray.cgColor
        eventDescriptionField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventNameField)
        view.addSubview(eventDateField)
        view.addSubview(eventDescriptionField)
        
        eventNameLabel.text = "Name:"
        eventNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventNameLabel)
        
        eventDateLabel.text = "Date:"
        eventDateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventDateLabel)
        
        eventDescriptionLabel.text = "Description:"
        eventDescriptionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        eventDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventDescriptionLabel)
        
        setupConstraints()
    }
    
    func setupConstraints () {
        
        NSLayoutConstraint.activate([
            titleof.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleof.topAnchor.constraint(equalTo: view.topAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            eventNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventNameLabel.topAnchor.constraint(equalTo: titleof.bottomAnchor, constant: 40),
            eventNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            eventNameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            eventNameField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            eventNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventNameField.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            eventDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventDateLabel.topAnchor.constraint(equalTo: eventNameField.bottomAnchor, constant: 15),
            eventDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            eventDateField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            eventDateField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            eventDateField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventDateField.topAnchor.constraint(equalTo: eventDateLabel.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            eventDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventDescriptionLabel.topAnchor.constraint(equalTo: eventDateField.bottomAnchor, constant: 15),
            eventDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            eventDescriptionField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            eventDescriptionField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            eventDescriptionField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventDescriptionField.topAnchor.constraint(equalTo: eventDescriptionLabel.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
        
    }

    @objc func savenew() {
        if let text1 = eventNameField.text, let text2 = eventDateField.text, let text3 = eventDescriptionField.text,
           text1.isEmpty || text2.isEmpty || text3.isEmpty {
            let alert = UIAlertController(title: "Error!", message: "Please fill out all event details!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
            present(alert, animated: true, completion: {
                return
            })
        }
        
        if let text1 = eventNameField.text, let text2 = eventDateField.text, let text3 = eventDescriptionField.text
              {
            delegate?.makeEvent(nametext: text1, datetext: text2, descriptext: text3)
            self.dismiss(animated: true)
        }
    }
}
    
    
    
protocol MakeEventDelegate: ViewController {
    func makeEvent(nametext: String, datetext: String, descriptext: String)
}


