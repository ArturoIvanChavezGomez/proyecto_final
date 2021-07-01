//
//  PizzaDetailViewController.swift
//  PizzApp
//
//  Created by Arturo Iván Chávez Gómez on 29/06/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class PizzaDetailViewController: UIViewController {
    
    @IBOutlet weak var pizzaImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addCartButton: UIButton!
    @IBOutlet weak var sodaStepper: UIStepper!
    @IBOutlet weak var frenchFriesStepper: UIStepper!
    @IBOutlet weak var saladStepper: UIStepper!
    @IBOutlet weak var sodaLabel: UILabel!
    @IBOutlet weak var frenchLabel: UILabel!
    @IBOutlet weak var saladLabel: UILabel!
    
    var pizzaImage: UIImage!
    var pizzaTitle: String!
    var pizzaDescription: String!
    var total: Int! = 0
    var totalPizza: Int! = 0
    var totalSoda: Int! = 0
    var totalFries: Int! = 0
    var totalSalad: Int! = 0
    var numberSodas: Int! = 0
    var numberFries: Int! = 0
    var numberSalads: Int! = 0
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        totalPizza = defaults.value(forKey: "price") as? Int
        addCartButton.setTitle(" $\(totalPizza!)", for: .normal)
        pizzaImage = UIImage.init(imageLiteralResourceName: defaults.value(forKey: "image") as! String)
        pizzaTitle = defaults.value(forKey: "name") as? String
        pizzaDescription = defaults.value(forKey: "description") as? String
        pizzaView()
    }
    
    private func pizzaView(){
        pizzaImageView.image = pizzaImage
        TitleLabel.text = pizzaTitle
        priceLabel.text = "$\(totalPizza!)"
        descriptionLabel.text = pizzaDescription
    }
    
    @IBAction func sodaStepperAction(_ sender: UIStepper) {
        sodaLabel.text = String(Int(sender.value))
        totalSoda = Int(sender.value) * 15
        numberSodas = Int(sender.value)
        total = totalPizza + totalSoda + totalFries + totalSalad
        addCartButton.setTitle(" $\(total!)", for: .normal)
    }
    
    
    @IBAction func saladStepperAction(_ sender: UIStepper) {
        saladLabel.text = String(Int(sender.value))
        totalSalad = Int(sender.value) * 30
        numberSalads = Int(sender.value)
        total = totalPizza + totalSoda + totalFries + totalSalad
        addCartButton.setTitle(" $\(total!)", for: .normal)
    }
    
    @IBAction func frenchFriesStepperAction(_ sender: UIStepper) {
        frenchLabel.text = String(Int(sender.value))
        totalFries = Int(sender.value) * 20
        numberFries = Int(sender.value)
        total = totalPizza + totalSoda + totalFries + totalSalad
        addCartButton.setTitle(" $\(total!)", for: .normal)
    }
    
    @IBAction func addToCartButtonAction(_ sender: UIButton) {
        
        let email = Auth.auth().currentUser?.email
        db.collection("users").document(email!).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, error == nil {
                if let name = document.get("name") as? String,
                   let lastName = document.get("lastName") as? String,
                   let phone = document.get("phone") as? String,
                   let location = document.get("location") as? String {
                    
                    if self.numberSodas == 0 && self.numberFries == 0 && self.numberSalads == 0 {
                        self.total = self.totalPizza
                    }
                    
                    let alert = UIAlertController(title: "Confirm order", message: "Your order is a \(self.pizzaTitle!), with Sodas: \(self.numberSodas!), French Fries: \(self.numberFries!), Salads: \(self.numberSalads!). Total is: $\(self.total!). This order is for \(name) \(lastName) at \(location) and phone number is \(phone)", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
                    }
                    
                    let acceptAction = UIAlertAction(title: "Order", style: .default) { (_) in
                        let okAlert = UIAlertController(title: "Congratulations!", message: "We recived your order. You'll get it in less than 30 minutes! 😉", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Ok", style: .default)
                        okAlert.addAction(ok)
                        self.present(okAlert, animated: true, completion: nil)
                    }
                    alert.addAction(acceptAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    let failAlert = UIAlertController(title: "Ups!", message: "You have to fill all your information on your profile and set a delivery address, try again!", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default)
                    failAlert.addAction(ok)
                    self.present(failAlert, animated: true, completion: nil)
                }
            }
        }
    }

}
