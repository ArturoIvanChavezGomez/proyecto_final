//
//  ProfileViewController.swift
//  PizzApp
//
//  Created by Arturo Iván Chávez Gómez on 23/06/21.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseAuth
import GoogleSignIn
import FacebookLogin
import FirebaseFirestore
import IQKeyboardManagerSwift

enum ProviderType: String {
    case basic
    case google
    case facebook
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var saveInfoButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    var email: String!
    var provider: ProviderType!
    
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        email = defaults.value(forKey: "email") as? String
        provider = ProviderType.init(rawValue: defaults.value(forKey: "provider") as! String)
        emailLabel.text = email
        
        db.collection("users").document(email!).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, error == nil {
                self.emailLabel.text = documentSnapshot?.documentID
                if let name = document.get("name") as? String {
                    self.nameTextField.text = name
                } else {
                    self.nameTextField.text = ""
                }
                if let lastName = document.get("lastName") as? String {
                    self.lastNameTextField.text = lastName
                } else {
                    self.lastNameTextField.text = ""
                }
                if let phone = document.get("phone") as? String {
                    self.phoneTextField.text = phone
                } else {
                    self.phoneTextField.text = ""
                }
                if let location = document.get("location") as? String {
                    self.locationLabel.text = location
                } else {
                    self.locationLabel.text = "No shipping address"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func saveInfoButtonAction(_ sender: UIButton) {
        if nameTextField.text != "" && lastNameTextField.text != "" && phoneTextField.text != "" {
            db.collection("users").document(email).setData([
                "provider":provider.rawValue,
                "name" : nameTextField.text ?? "",
                "lastName" : lastNameTextField.text ?? "",
                "phone" : phoneTextField.text ?? ""
            ], merge: true)
            
            let alert = UIAlertController(title: "Saved", message: "Your information was saved successfuly!", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
            alert.addAction(accept)
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "You have to fill all fields!", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
            alert.addAction(accept)
            present(alert, animated: true)
        }
        
    }
    
    @IBAction func logOutButtonAction(_ sender: UIButton) {
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.set(false, forKey: "onboarding")
        
        switch provider {
        case .basic:
            firebaseLogOut()
        case .google:
            GIDSignIn.sharedInstance()?.signOut()
            firebaseLogOut()
        case .facebook:
            LoginManager().logOut()
            firebaseLogOut()
        default:
            print("Adios")
        }
        
        let view = storyboard?.instantiateViewController(identifier: "AuthViewController")
        view?.modalPresentationStyle = .fullScreen
        view?.modalTransitionStyle = .coverVertical
        present(view!, animated: true, completion: nil)
    }
    
    private func firebaseLogOut() {
        do {
            try Auth.auth().signOut()
        } catch  {
            print("Error al cerrar sesión")
        }
    }
    
}
