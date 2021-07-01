//
//  HomeViewController.swift
//  PizzApp
//
//  Created by Arturo Iván Chávez Gómez on 25/06/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var specialsCollectionView: UICollectionView!
    @IBOutlet weak var allCollectionView: UICollectionView!
    
    var populars: [Pizza] = [
        .init(id: "id1", name: "Pepperoni", description: "The most popular pizza. This beauty has everything you need, pepperoni & double cheese, no more, it's perfect. ❤️", image: #imageLiteral(resourceName: "pepperoni"), imageName: "pepperoni", price: 100),
        
        .init(id: "id2", name: "Hawaiian", description: "Classic Hawaiian Pizza combines pizza sauce, cheese, cooked ham & pineapple. This taste of the tropics brings a beach vacation on Flavour Island!", image: #imageLiteral(resourceName: "hawaiian"), imageName: "hawaiian", price: 120),
        
        .init(id: "id3", name: "Pizza Cheese", description: "If you're looking for an ultra cheesy pizza then look no further than this classic! Contains tomato sauce, mozzarella, gorgonzola, parmigiano reggiano, & goat cheese.", image:#imageLiteral(resourceName: "chesee"), imageName: "chesee", price: 140)
    ]
    
    var specials: [Pizza] = [
        .init(id: "id4", name: "Italian", description: "Full of flavors, Italian pizza brings a delicius ingredients as black olive, pepper, mushrooms, pepperoni & beef. Nobody can't resist to this baby!", image: #imageLiteral(resourceName: "italian"), imageName: "italian", price: 150),
        
        .init(id: "id5", name: "Hawaiian Chiken", description: "The original & loved hawaiian pizza with extra ingredients, purple onion, parsley & chiken! This mix makes people crazy. 😜", image: #imageLiteral(resourceName: "chiken"), imageName: "chiken", price: 145),
        
        .init(id: "id6", name: "Vegetarian", description: "Are you vegetarian or do you like vegetables a lot? Great, vegetarian pizza is made with peppers, mushrooms, corn & onion. Awesome!", image:#imageLiteral(resourceName: "vegetarian"), imageName: "vegetarian", price: 130),
        
        .init(id: "id7", name: "Shrimp Pizza", description: "Yes, Shrimp! If you can't believe it, you have to taste it!. This pizza contains parsley, sesame grains, double cheese & obviously, SHRIMP!", image:#imageLiteral(resourceName: "shrimp"), imageName: "shrimp", price: 170),
        
        .init(id: "id8", name: "Original", description: "The original baby! Come from Italy and it brings the most national flavor. Made with green fresh basil, red tomato sauce & white mozzarella, all you really need.", image:#imageLiteral(resourceName: "original"), imageName: "original", price: 160)
    ]
    
    var all: [Pizza] = [
        .init(id: "id5", name: "Hawaiian Chiken", description: "The original & loved hawaiian pizza with extra ingredients, purple onion, parsley & chiken! This mix makes people crazy. 😜", image: #imageLiteral(resourceName: "chiken"), imageName: "chiken", price: 145),
        
        .init(id: "id4", name: "Italian", description: "Full of flavors, Italian pizza brings a delicius ingredients as black olive, pepper, mushrooms, pepperoni & beef. Nobody can't resist to this baby!", image: #imageLiteral(resourceName: "italian"), imageName: "italian", price: 150),
        
        .init(id: "id7", name: "Shrimp Pizza", description: "Yes, Shrimp! If you can't believe it, you have to taste it!. This pizza contains parsley, sesame grains, double cheese & obviously, SHRIMP!", image:#imageLiteral(resourceName: "shrimp"), imageName: "shrimp", price: 170),
        
        .init(id: "id8", name: "Original", description: "The original baby! Come from Italy and it brings the most national flavor. Made with green fresh basil, red tomato sauce & white mozzarella, all you really need.", image:#imageLiteral(resourceName: "original"), imageName: "original", price: 160),
        
        .init(id: "id3", name: "Pizza Cheese", description: "If you're looking for an ultra cheesy pizza then look no further than this classic! Contains tomato sauce, mozzarella, gorgonzola, parmigiano reggiano, & goat cheese.", image:#imageLiteral(resourceName: "chesee"), imageName: "chesee", price: 140),
        
        .init(id: "id1", name: "Pepperoni", description: "The most popular pizza. This beauty has everything you need, pepperoni & double cheese, no more, it's perfect. ❤️", image: #imageLiteral(resourceName: "pepperoni"), imageName: "pepperoni", price: 100),
        
        .init(id: "id6", name: "Vegetarian", description: "Are you vegetarian or do you like vegetables a lot? Great, vegetarian pizza is made with peppers, mushrooms, corn & onion. Awesome!", image:#imageLiteral(resourceName: "vegetarian"), imageName: "vegetarian", price: 130),
        
        .init(id: "id2", name: "Hawaiian", description: "Classic Hawaiian Pizza combines pizza sauce, cheese, cooked ham & pineapple. This taste of the tropics brings a beach vacation on Flavour Island!", image: #imageLiteral(resourceName: "hawaiian"), imageName: "hawaiian", price: 120),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    private func registerCells(){
        popularCollectionView.register(UINib(nibName: PopularCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PopularCollectionViewCell.identifier)
        
        specialsCollectionView.register(UINib(nibName: SpecialsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SpecialsCollectionViewCell.identifier)
        
        allCollectionView.register(UINib(nibName: AllCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: AllCollectionViewCell.identifier)
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case popularCollectionView:
            return populars.count
        case specialsCollectionView:
            return specials.count
        case allCollectionView:
            return all.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case popularCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCollectionViewCell.identifier, for: indexPath) as! PopularCollectionViewCell
            cell.setup(pizza: populars[indexPath.row])
            return cell
        case specialsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpecialsCollectionViewCell.identifier, for: indexPath) as! SpecialsCollectionViewCell
            cell.setup(pizza: specials[indexPath.row])
            return cell
        case allCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllCollectionViewCell.identifier, for: indexPath) as! AllCollectionViewCell
            cell.setup(pizza: all[indexPath.row])
            return cell
        default: return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == popularCollectionView {
            let defaults = UserDefaults.standard
            defaults.set(populars[indexPath.row].imageName, forKey: "image")
            defaults.set(populars[indexPath.row].name, forKey: "name")
            defaults.set(populars[indexPath.row].price, forKey: "price")
            defaults.set(populars[indexPath.row].description, forKey: "description")
        } else if collectionView == specialsCollectionView {
            let defaults = UserDefaults.standard
            defaults.set(specials[indexPath.row].imageName, forKey: "image")
            defaults.set(specials[indexPath.row].name, forKey: "name")
            defaults.set(specials[indexPath.row].price, forKey: "price")
            defaults.set(specials[indexPath.row].description, forKey: "description")
        } else {
            let defaults = UserDefaults.standard
            defaults.set(all[indexPath.row].imageName, forKey: "image")
            defaults.set(all[indexPath.row].name, forKey: "name")
            defaults.set(all[indexPath.row].price, forKey: "price")
            defaults.set(all[indexPath.row].description, forKey: "description")
        }
        performSegue(withIdentifier: "toPizzaDetailSegue", sender: self)
    }
    
}
