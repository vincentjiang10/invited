//
//  EventMakerViewController.swift
//  finalproj
//
//  Created by Big Mac on 4/30/23.
//

import UIKit

class EventMakerViewController: UIViewController {

    var cancel = UIBarButtonItem()
    let eventNameLabel = UILabel()
    let eventStartDateLabel = UILabel()
    let eventEndDateLabel = UILabel()
    let eventLoc = UILabel()
    let eventAcc = UILabel()
    let eventDescriptionLabel = UILabel()
    
    let eventNameField = UITextField()
    let eventStartDateField = UITextField()
    let eventEndDateField = UITextField()
    let eventDescriptionField = UITextField()
    let eventLocField = UITextField()
    let eventAccField = UITextField()
    
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
        
        title = "Make an Event!"
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        
        cancel = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelEvent))
        navigationItem.leftBarButtonItem = cancel
        
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.blue, for: .normal)
        saveButton.addTarget(self, action: #selector(savenew), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: eventNameField.frame.height))
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: eventNameField.frame.height))
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: eventNameField.frame.height))
        let paddingView3 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: eventNameField.frame.height))
        let paddingView4 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: eventNameField.frame.height))
        let paddingView5 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: eventNameField.frame.height))
        
        eventNameField.leftView = paddingView
        eventNameField.leftViewMode = .always
        eventStartDateField.leftView = paddingView1
        eventStartDateField.leftViewMode = .always
        eventEndDateField.leftView = paddingView2
        eventEndDateField.leftViewMode = .always
        eventLocField.leftView = paddingView3
        eventLocField.leftViewMode = .always
        eventAccField.leftView = paddingView4
        eventAccField.leftViewMode = .always
        eventDescriptionField.leftView = paddingView5
        eventDescriptionField.leftViewMode = .always
        
        eventNameField.placeholder = "Name of your Event!"
        eventNameField.textAlignment = .left
        eventNameField.backgroundColor = UIColor.white
        eventNameField.font = UIFont.systemFont(ofSize: 14)
        eventStartDateField.placeholder = "When does it start? (MM/DD/YY)"
        eventStartDateField.textAlignment = .left
        eventStartDateField.backgroundColor = UIColor.white
        eventStartDateField.font = UIFont.systemFont(ofSize: 14)
        eventEndDateField.placeholder = "When does it end? (MM/DD/YY)"
        eventEndDateField.textAlignment = .left
        eventEndDateField.backgroundColor = UIColor.white
        eventEndDateField.font = UIFont.systemFont(ofSize: 14)
        eventLocField.placeholder = "Where is it happenin'"
        eventLocField.textAlignment = .left
        eventLocField.backgroundColor = UIColor.white
        eventLocField.font = UIFont.systemFont(ofSize: 14)
        eventAccField.placeholder = "Is this a private or public event?"
        eventAccField.textAlignment = .left
        eventAccField.backgroundColor = UIColor.white
        eventAccField.font = UIFont.systemFont(ofSize: 14)
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
        eventStartDateField.borderStyle = .roundedRect
        eventStartDateField.layer.cornerRadius = 9
        eventStartDateField.layer.backgroundColor = CGColor.init(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        eventStartDateField.layer.borderWidth = 1
        eventStartDateField.layer.borderColor = UIColor.black.cgColor
        eventStartDateField.layer.cornerRadius = 5
        eventStartDateField.layer.borderColor = UIColor.gray.cgColor
        eventStartDateField.translatesAutoresizingMaskIntoConstraints = false
        eventEndDateField.borderStyle = .roundedRect
        eventEndDateField.layer.cornerRadius = 9
        eventEndDateField.layer.borderWidth = 1
        eventEndDateField.layer.backgroundColor = CGColor.init(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        eventEndDateField.layer.borderColor = UIColor.black.cgColor
        eventEndDateField.layer.cornerRadius = 5
        eventEndDateField.layer.borderColor = UIColor.gray.cgColor
        eventEndDateField.translatesAutoresizingMaskIntoConstraints = false
        eventDescriptionField.borderStyle = .roundedRect
        eventDescriptionField.layer.cornerRadius = 9
        eventDescriptionField.layer.backgroundColor = CGColor.init(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        eventDescriptionField.layer.borderWidth = 1
        eventDescriptionField.layer.borderColor = UIColor.black.cgColor
        eventDescriptionField.layer.cornerRadius = 5
        eventDescriptionField.layer.borderColor = UIColor.gray.cgColor
        eventDescriptionField.translatesAutoresizingMaskIntoConstraints = false
        eventLocField.borderStyle = .roundedRect
        eventLocField.layer.cornerRadius = 9
        eventLocField.layer.backgroundColor = CGColor.init(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        eventLocField.layer.borderWidth = 1
        eventLocField.layer.borderColor = UIColor.black.cgColor
        eventLocField.layer.cornerRadius = 5
        eventLocField.layer.borderColor = UIColor.gray.cgColor
        eventLocField.translatesAutoresizingMaskIntoConstraints = false
        eventAccField.borderStyle = .roundedRect
        eventAccField.layer.cornerRadius = 9
        eventAccField.layer.backgroundColor = CGColor.init(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        eventAccField.layer.borderWidth = 1
        eventAccField.layer.borderColor = UIColor.black.cgColor
        eventAccField.layer.cornerRadius = 5
        eventAccField.layer.borderColor = UIColor.gray.cgColor
        eventAccField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(eventNameField)
        view.addSubview(eventStartDateField)
        view.addSubview(eventEndDateField)
        view.addSubview(eventLocField)
        view.addSubview(eventAccField)
        view.addSubview(eventDescriptionField)
        
        eventNameLabel.text = "Name:"
        eventNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventNameLabel)
        
        eventStartDateLabel.text = "Start Date:"
        eventStartDateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        eventStartDateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventStartDateLabel)
        
        eventEndDateLabel.text = "End Date:"
        eventEndDateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        eventEndDateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventEndDateLabel)
        
        eventLoc.text = "Location:"
        eventLoc.font = UIFont.boldSystemFont(ofSize: 20)
        eventLoc.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventLoc)
        
        eventAcc.text = "Public or Private:"
        eventAcc.font = UIFont.boldSystemFont(ofSize: 20)
        eventAcc.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventAcc)
        
        eventDescriptionLabel.text = "Description:"
        eventDescriptionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        eventDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventDescriptionLabel)
        
        setupConstraints()
    }
    
    func setupConstraints () {
        
        NSLayoutConstraint.activate([
            eventNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            eventNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            eventNameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            eventNameField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            eventNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventNameField.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            eventStartDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventStartDateLabel.topAnchor.constraint(equalTo: eventNameField.bottomAnchor, constant: 15),
            eventStartDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            eventStartDateField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            eventStartDateField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            eventStartDateField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventStartDateField.topAnchor.constraint(equalTo: eventStartDateLabel.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            eventEndDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventEndDateLabel.topAnchor.constraint(equalTo: eventStartDateField.bottomAnchor, constant: 15),
            eventEndDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            eventEndDateField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            eventEndDateField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            eventEndDateField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventEndDateField.topAnchor.constraint(equalTo: eventEndDateLabel.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            eventLoc.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventLoc.topAnchor.constraint(equalTo: eventEndDateField.bottomAnchor, constant: 15),
            eventLoc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            eventLocField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            eventLocField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            eventLocField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventLocField.topAnchor.constraint(equalTo: eventLoc.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            eventAcc.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventAcc.topAnchor.constraint(equalTo: eventLocField.bottomAnchor, constant: 15),
            eventAcc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            eventAccField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            eventAccField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            eventAccField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventAccField.topAnchor.constraint(equalTo: eventAcc.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            eventDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventDescriptionLabel.topAnchor.constraint(equalTo: eventAccField.bottomAnchor, constant: 15),
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
        // rotating view, for selecting from a list of items
        // uipicker view for dropdown menu
    }
    func isValidDateFormat(_ dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: dateString) != nil
    }
    
    @objc func cancelEvent() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func savenew() {
        if let text1 = eventNameField.text, let text2 = eventStartDateField.text, let text3 = eventEndDateField.text, let text4 = eventDescriptionField.text, let text5 = eventLocField.text, let text6 = eventAccField.text,
           text1.isEmpty || text2.isEmpty || text3.isEmpty || text4.isEmpty || text5.isEmpty || text6.isEmpty {
            let alert = UIAlertController(title: "Error!", message: "Please fill out all event details!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
            present(alert, animated: true, completion: {
                return
            })
        }
        
        else if let text1 = eventStartDateField.text, let text2 = eventEndDateField.text, !isValidDateFormat(text1) || !isValidDateFormat(text2)
        {
            let alert = UIAlertController(title: "Error!", message: "Please write the date correctly in MM/DD/YY form!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
            present(alert, animated: true, completion: {
                return
        })
                    }
        
        else if let text1 = eventNameField.text, let text2 = eventStartDateField.text, let text3 = eventEndDateField.text, let text4 = eventLocField.text, let text5 = eventAccField.text, let text6 = eventDescriptionField.text, isValidDateFormat(text2) && isValidDateFormat(text3)
              {
            delegate?.createEvent(nametext: text1, starttime: text2, endtime: text3, loc: text4, acc: text5, descrip: text6)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
    
    
    
protocol MakeEventDelegate: ViewController {
    func createEvent(nametext: String, starttime: String, endtime: String, loc: String, acc: String, descrip: String)
}


