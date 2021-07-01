//
//  OrdersListTableViewCell.swift
//  PizzApp
//
//  Created by Arturo Iván Chávez Gómez on 30/06/21.
//

import UIKit

class OrdersListTableViewCell: UITableViewCell {

    @IBOutlet weak var pizzaImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pizzaLabel: UILabel!
    @IBOutlet weak var sodaLabel: UILabel!
    @IBOutlet weak var friesLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    func setup(order: Order){
        pizzaImageView.image = order.pizza?.image
        nameLabel.text = order.name
        pizzaLabel.text = order.pizza?.name
        sodaLabel.text = "\(order.soda!)"
        friesLabel.text = "\(order.fries!)"
        totalLabel.text = "\(order.total)"
    }
    
}
