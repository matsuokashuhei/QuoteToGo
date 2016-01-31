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

    var optionsMenu: QuoteMenu!

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 9
    }
   
    @IBAction func displayOptions(sender: AnyObject) {
        let quoteMenu = NSBundle.mainBundle().loadNibNamed("QuoteMenu", owner: self, options: nil).last as! QuoteMenu
        quoteMenu.frame = CGRectMake(0, -300, view.bounds.size.width, 300)
        optionsMenu = quoteMenu
        quoteMenu.quoteImageButton.addTarget(self, action: "createQuoteImage", forControlEvents: .TouchUpInside)
        quoteMenu.shareQuoteButton.addTarget(self, action: "shareQuote", forControlEvents: .TouchUpInside)
        quoteMenu.deleteQuoteButton.addTarget(self, action: "deleteQuote", forControlEvents: .TouchUpInside)
        view.addSubview(quoteMenu)
        smallBookmarkTopConstraint.constant = 254
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: { () -> Void in
            var newQuoteMenuFrame = quoteMenu.frame
            newQuoteMenuFrame.origin.y = -44
            quoteMenu.frame = newQuoteMenuFrame
            self.dateLabel.alpha = 0
            self.view.layoutIfNeeded()
            }) { (success) -> Void in
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "hideOnTap:")
                gestureRecognizer.numberOfTapsRequired = 1
                self.view.addGestureRecognizer(gestureRecognizer)
        }
    }

    func hideOptions() {
        if let menu = optionsMenu {
            smallBookmarkTopConstraint.constant = 0
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: { () -> Void in
                var newQuoteMenuFrame = menu.frame
                newQuoteMenuFrame.origin.y = -300
                menu.frame = newQuoteMenuFrame
                self.view.layoutIfNeeded()
                }, completion: { (success) -> Void in
                    menu.removeFromSuperview()
                    self.optionsMenu = nil
            })
        }
    }

    func hideOnTap(recognizer: UITapGestureRecognizer) {
        hideOptions()
        view.removeGestureRecognizer(recognizer)
    }

    func createQuoteImage() {
        performSegueWithIdentifier("createQuoteImage", sender: self)
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) { () -> Void in
            self.hideOptions()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createQuoteImage" {
            let quoteImageVC = segue.destinationViewController as! QuoteImageViewController
            quoteImageVC.quoteText = quoteTextView.text
            quoteImageVC.author = authorNameLabel.text
        }
    }

    func shareQuote() {
        let quoteString = "\"\(quote.content!)\" - \(quote.author!.name!)"
        let activityController = UIActivityViewController(activityItems: [quoteString], applicationActivities: nil)
        hideOptions()
        self.presentViewController(activityController, animated: true, completion: nil)
    }

    func deleteQuote() {
        quote.managedObjectContext?.deleteObject(quote)
        try! moc.save()
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.addAnimation(transition, forKey: nil)
        self.navigationController?.popViewControllerAnimated(false)
    }

}
