//
//  AllCollectionViewCell.swift
//  PizzApp
//
//  Created by Arturo Iván Chávez Gómez on 29/06/21.
//

import UIKit

class AllCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: AllCollectionViewCell.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pizzaImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setup(pizza: Pizza){
        pizzaImageView.image = pizza.image
        titleLabel.text = pizza.name
        descriptionLabel.text = pizza.description
        priceLabel.text = "$\(pizza.price!)"
    }

}
