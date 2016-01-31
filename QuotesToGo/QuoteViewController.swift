//
//  QuoteViewController.swift
//  QuotesToGo
//


import UIKit

class QuoteViewController: UIViewController {


    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var authorBackgroundImageView: UIImageView!
    @IBOutlet weak var smallBookmarkTopConstraint: NSLayoutConstraint!



    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
    }
    
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

   
}
