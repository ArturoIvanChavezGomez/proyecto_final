//
//  String+Extension.swift
//  PizzApp
//
//  Created by Arturo Iván Chávez Gómez on 28/06/21.
//

import Foundation

extension String {
    var asUrl: URL? {
        return URL(string: self)
    }
}
