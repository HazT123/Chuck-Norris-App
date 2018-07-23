//
//  NeverEndingViewController.swift
//  Chuck-Norris-Facts
//
//  Created by Codenation10 on 11/07/2018.
//  Copyright © 2018 Codenation. All rights reserved.
//

import UIKit

class NeverEndingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    private var jokesArray = [Jokes]()
    var noExplicit = ""

    //add facts to jokesArray on load and reload the thread
    override func viewDidLoad() {
        super.viewDidLoad()
            Jokes.ChuckNorrisJoke(neverEnding: true, caseURL: "50" + noExplicit) { (results:[Jokes]) in
                for result in results {
                    self.jokesArray.append(result)
                }
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    //return the number of jokes in jokesArray to give the number of rows needed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokesArray.indices.count
    }
    
    //set the height for each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    //create each cell with next joke in jokesArray
    //when the user scrolls to the end make another request for jokes and refresh
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jokeCell") as! JokeCell
        let joke = jokesArray[indexPath.row]
        let returnedJoke = joke.joke.removeQuotes(joke: joke.joke)
        cell.setLabel(joke: returnedJoke)
        if indexPath.row + 1 == jokesArray.count {
            requestJokes()
        }
        return cell
    }
    
    //asynch call another list of 50 jokes
    func requestJokes() {
        Jokes.ChuckNorrisJoke(neverEnding: true, caseURL: "50"  + noExplicit) { (results:[Jokes]) in
            for result in results {
                self.jokesArray.append(result)
            }
            Thread.sleep(forTimeInterval: 0.2)
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        }
    }
}
