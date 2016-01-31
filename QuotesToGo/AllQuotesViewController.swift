//
//  AllQuotesViewController.swift
//  QuotesToGo
//


import UIKit

class AllQuotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var ribbonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var ribbon: UIImageView!
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var quotesTableView: UITableView!
    
    @IBOutlet weak var searchButton: UIButton!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! QuoteTableViewCell
        
        return cell
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
