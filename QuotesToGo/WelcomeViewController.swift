//
//  WelcomeViewController.swift
//  QuotesToGo
//

import UIKit
import CoreData

class WelcomeViewController: UIViewController {

    @IBOutlet weak var ribbon: UIImageView!
    @IBOutlet weak var dailyQuoteTextView: UITextView!    
    @IBOutlet weak var dailyQuoteAuthor: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var saveQuoteButton: UIButton!
    
    var randomQuote: NSArray!
    var selectedRandomQuote: [String: String]!

    // Constraint outlets for animation
    @IBOutlet weak var quoteToGoLabelCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var quoteWidthConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let path = NSBundle.mainBundle().pathForResource("DailyQuotes", ofType: "plist") {
            randomQuote = NSArray(contentsOfFile: path)
        }
    }

    func chooseRandomQuote() {
        let randomQuoteIndex = Int(arc4random_uniform(UInt32(randomQuote.count)))
        selectedRandomQuote = randomQuote.objectAtIndex(randomQuoteIndex) as! [String: String]
        dailyQuoteAuthor.text = selectedRandomQuote["author"]
        dailyQuoteTextView.text = selectedRandomQuote["quote"]
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        chooseRandomQuote()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

