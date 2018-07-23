//
//  jokeCell.swift
//  Chuck-Norris-Facts
//
//  Created by Codenation10 on 11/07/2018.
//  Copyright © 2018 Codenation. All rights reserved.
//

import UIKit

class JokeCell: UITableViewCell {
    
    @IBOutlet weak var jokeLabel: UILabel!
    // set the label in each cell with next joke
    func setLabel(joke: String) {
        jokeLabel.text = joke
    }

}
