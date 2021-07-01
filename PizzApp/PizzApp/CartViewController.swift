//
//  CartViewController.swift
//  PizzApp
//
//  Created by Arturo Iván Chávez Gómez on 25/06/21.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var ordersTableView: UITableView!
    
    var orders: [Order] = [
        .init(name: "Ivan", pizza: .init(id: "id1", name: "Pepperoni", description: "The most popular pizza. This beauty has everything you need, pepperoni & double cheese, no more, it's perfect. ❤️", image: #imageLiteral(resourceName: "pepperoni"), imageName: "pepperoni", price: 100), soda: 2, fries: 3, total: 150),
        .init(name: "Ivan", pizza: .init(id: "id1", name: "Pepperoni", description: "The most popular pizza. This beauty has everything you need, pepperoni & double cheese, no more, it's perfect. ❤️", image: #imageLiteral(resourceName: "pepperoni"), imageName: "pepperoni", price: 100), soda: 2, fries: 3, total: 150),
        .init(name: "Ivan", pizza: .init(id: "id1", name: "Pepperoni", description: "The most popular pizza. This beauty has everything you need, pepperoni & double cheese, no more, it's perfect. ❤️", image: #imageLiteral(resourceName: "pepperoni"), imageName: "pepperoni", price: 100), soda: 2, fries: 3, total: 150)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }

    private func registerCells(){
        ordersTableView.register(UINib(nibName: "OrdersListTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersListTableViewCell")
    }
    
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersListTableViewCell") as! OrdersListTableViewCell
        cell.setup(order: orders[indexPath.row])
        return cell
    }
}
