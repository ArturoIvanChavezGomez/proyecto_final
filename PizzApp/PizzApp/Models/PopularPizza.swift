//
//  PopularPizza.swift
//  PizzApp
//
//  Created by Arturo Iván Chávez Gómez on 28/06/21.
//

import UIKit

struct PopularPizza {
    let id: String?
    let name: String?
    let description: String?
    let image: UIImage?
    let price: Double?
    
    var formattedPrice: String {
        return String(format: "%2f0", price ?? 0)
    }
}
