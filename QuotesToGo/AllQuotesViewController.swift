//
//  AllQuotesViewController.swift
//  QuotesToGo
//


import UIKit

class AllQuotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var ribbonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var ribbon: UIImageView!
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var quotesTableView: UITableView! {
        didSet {
            quotesTableView.delegate = self
            quotesTableView.dataSource = self
            quotesTableView.separatorStyle = .None
            quotesTableView.showsVerticalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var searchButton: UIButton!
    
    var moc: NSManagedObjectContext!
    var quotes = [Quote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moc = CoreDataHelper.managedObjectContext()
        createBorder()
        loadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    func createBorder() {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor(white: 0.95, alpha: 1).CGColor
        borderLayer.lineWidth = 24
        borderLayer.fillColor = UIColor.clearColor().CGColor
        borderLayer.path = UIBezierPath(rect: self.view.bounds).CGPath
        borderView.layer.addSublayer(borderLayer)
    }

    func loadData() {
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        quotes = CoreDataHelper.fetchEntities(NSStringFromClass(Quote), managedObjectContext: moc, predicate: nil, sortDescriptor: sortDescriptor) as! [Quote]
        quotesTableView.reloadData()
    }

    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! QuoteTableViewCell
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView?.backgroundColor = UIColor.clearColor()
        if let quote = quotes[indexPath.row] as Quote? {
            if let author = quote.author {
                cell.quoteLabel.text = quote.content
                cell.authorLabel.text = author.name
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                cell.dataLabel.text = dateFormatter.stringFromDate(quote.createdAt!)
                if let data = author.image {
                    let image = UIImage(data: data)
                    cell.authorImageView.image = image
                } else {
                    cell.authorImageView.image = UIImage(named: "avatar")
                }
            }
        }
        return cell
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
