//
//  ProfileViewController.swift
//  finalproj
//
//  Created by Big Mac on 4/28/23.
//

import UIKit

class ProfileViewController: UIViewController {
    var back = UIBarButtonItem()
    var savebutt = UIBarButtonItem()
    let nameLabel = UILabel()
    let nameField = UITextField()
    let emailLabel = UILabel()
    let emailField = UITextField()
    weak var delegate: ChangeTextDelegate?
    
    init(inputDelegate: ChangeTextDelegate) {
        delegate = inputDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        title = "Edit My Profile"
        navigationController?.navigationBar.isTranslucent = true
        view.backgroundColor = .white
        
        back = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = back
        
        savebutt = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChanges))
        navigationItem.rightBarButtonItem = savebutt
        
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameField.frame.height))
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameField.frame.height))
        
        nameField.leftView = paddingView
        nameField.leftViewMode = .always
        emailField.leftView = paddingView1
        emailField.leftViewMode = .always
        
        nameField.placeholder = "Name"
        nameField.textAlignment = .left
        nameField.backgroundColor = UIColor.white
        nameField.font = UIFont.systemFont(ofSize: 14)
        emailField.placeholder = "Add your Email"
        emailField.textAlignment = .left
        emailField.backgroundColor = UIColor.white
        emailField.font = UIFont.systemFont(ofSize: 14)
        
        nameField.borderStyle = .roundedRect
        nameField.layer.cornerRadius = 9
        nameField.layer.borderWidth = 1
        nameField.layer.backgroundColor = CGColor.init(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        nameField.layer.borderColor = UIColor.black.cgColor
        nameField.layer.cornerRadius = 5
        nameField.layer.borderColor = UIColor.gray.cgColor
        nameField.translatesAutoresizingMaskIntoConstraints = false
        emailField.borderStyle = .roundedRect
        emailField.layer.cornerRadius = 9
        emailField.layer.backgroundColor = CGColor.init(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.layer.cornerRadius = 5
        emailField.layer.borderColor = UIColor.gray.cgColor
        emailField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameField)
        view.addSubview(emailField)
        
        nameLabel.text = "Name"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        emailLabel.text = "Email"
        emailLabel.font = UIFont.boldSystemFont(ofSize: 20)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        
        
        setupConstraints()
    }
    
    func setupConstraints () {
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            nameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            nameField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 15),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            emailField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10)
        ])
        
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func saveChanges() {
        if let text1 = nameField.text, let text2 = emailField.text,
           text1.isEmpty || text2.isEmpty {
            let alert = UIAlertController(title: "Error!", message: "Please fill out your name and email properly.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
            present(alert, animated: true, completion: {
                return
            })
        }
        
        if let text1 = nameField.text, let text2 = emailField.text
              {
            delegate?.changeText(nametext: text1, emailtext: text2)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
    
    
    
protocol ChangeTextDelegate: ViewController {
    func changeText(nametext: String, emailtext: String)
}


