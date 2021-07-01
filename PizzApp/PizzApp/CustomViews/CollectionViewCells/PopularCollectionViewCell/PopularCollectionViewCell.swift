//
//  PopularCollectionViewCell.swift
//  PizzApp
//
//  Created by Arturo Iván Chávez Gómez on 28/06/21.
//

import UIKit
import Kingfisher

class PopularCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: PopularCollectionViewCell.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pizzaImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setup(pizza: Pizza){
        titleLabel.text = pizza.name
        pizzaImageView.image = pizza.image
        descriptionLabel.text = pizza.description
        priceLabel.text = "$\(pizza.price!)"
    }

}
