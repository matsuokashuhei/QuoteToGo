//
//  QuoteViewController.swift
//  QuotesToGo
//


import UIKit

class QuoteViewController: UIViewController, UITextViewDelegate, NSLayoutManagerDelegate {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var authorBackgroundImageView: UIImageView!
    @IBOutlet weak var smallBookmarkTopConstraint: NSLayoutConstraint!

    var moc: NSManagedObjectContext!
    var quote: Quote!

    override func viewDidLoad() {
        super.viewDidLoad()
        moc = CoreDataHelper.managedObjectContext()
        quoteTextView.delegate = self
        quoteTextView.layoutManager.delegate = self
        createBorder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setQuoteInformation()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if quoteTextView.text != quote.content {
            quote.content = quoteTextView.text
            try! moc.save()
        }
    }

    func createBorder() {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor(white: 0.95, alpha: 1).CGColor
        borderLayer.lineWidth = 24
        borderLayer.fillColor = UIColor.clearColor().CGColor
        borderLayer.path = UIBezierPath(rect: self.view.bounds).CGPath
        borderView.layer.addSublayer(borderLayer)
    }

    func setQuoteInformation() {
        let author = quote.author
        if let imageData = author?.image {
            authorImageView.image = UIImage(data: imageData)
        } else {
            authorBackgroundImageView.alpha = 0
            authorImageView.image = UIImage(named: "avatarBig")
        }
        ImageMasker.maskImage(authorImageView, size: CGSize(width: 118, height: 118))
        authorNameLabel.text = author!.name!.uppercaseString
        quoteTextView.text = quote.content
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let dateString = dateFormatter.stringFromDate(quote.createdAt!)
        dateLabel.text = dateString
    }

    @IBAction func dismiss(sender: AnyObject) {
        let button = sender as! UIButton
        button.enabled = false
        navigationController?.popViewControllerAnimated(true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 9
    }
   

   
}
