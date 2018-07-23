//
//  ViewController.swift
//  Chuck-Norris-Facts
//
//  Created by Codenation10 on 09/07/2018.
//  Copyright © 2018 Codenation. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var noExplicit = false

    @IBOutlet weak var characterName: UITextField!
    //set the value for Explicit jokes on or off depending on the switches state
    @IBAction private func noExplicit(_ sender: UISwitch) {
        noExplicit = sender.isOn ? true : false
    }
    
    //request 1 joke and display in a popUp
    @IBAction private func randomJoke(_ sender: UIButton) {
        Jokes.ChuckNorrisJoke(neverEnding: false, caseURL: NoExplicit()) { (results:[Jokes]) in
            for result in results {
                let returnedJoke = result.joke.removeQuotes(joke: result.joke)
                self.popUp(message: returnedJoke)
            }
        }
    }
    
    //users entered name will be formatted and sent to api, returning a joke with users name
    @IBAction private func jokeWithName(_ sender: UIButton) {
        characterName.resignFirstResponder()
        if characterName.text == "" {
            self.popUp(message: "No name inserted")
        } else {
            var formattedName = characterName.text!
            formattedName.formatName()
            Jokes.ChuckNorrisJoke(neverEnding: false, caseURL: NoExplicit() + formattedName) { (results:[Jokes]) in
                for result in results {
                    let returnedJoke = result.joke.removeQuotes(joke: result.joke)
                    self.popUp(message: returnedJoke)
                }
            }
        }
    }
    
    // popUp message function
    private func popUp(message: String) {
        assert(message.indices.count > 0, "ViewController(\(message)): must have input")
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        characterName.delegate = self
    }
    
    // set text to nothing or return string that will exclude explicit jokes
    private func NoExplicit() -> String {
        return noExplicit ? "exclude=[explicit]" : ""
    }
    
    //grab neverEndingViewController and give its local variable to the value of the string NoExplicit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let sc = nav.topViewController as? NeverEndingViewController {
            sc.noExplicit = NoExplicit()
        }
    }
    
}

// resigns keyboard when enter is pressed
extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//removes quotes from jokes
public extension String {
    func removeQuotes(joke : String) -> String {
        return joke.replacingOccurrences(of: "&quot;", with: "'")
    }
}

//accepts a name and returns a formatted string to be sent to api
private extension String {
    mutating func formatName() {
        self = "?firstName=" + self.components(separatedBy: " ")[0] + "&amp;?lastName=" + self.components(separatedBy: " ")[1]
    }
}
