//
//  AddQuoteViewController.swift
//  QuotesToGo
//

import UIKit

class AddQuoteViewController: UIViewController, UITextViewDelegate, NSLayoutManagerDelegate {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var test: UIImageView!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var donebutton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    var moc: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        moc = CoreDataHelper.managedObjectContext()
        quoteTextView.delegate = self
        quoteTextView.layoutManager.delegate = self
    }

    @IBAction func addNewQuote(sender: AnyObject) {
        quoteTextView.resignFirstResponder()
        authorTextField.resignFirstResponder()
        if quoteTextView.text != "" {
            donebutton.enabled = false
            backButton.enabled = false
            let quote = CoreDataHelper.insertManagedObject(NSStringFromClass(Quote), managedObjectContext: moc) as! Quote
            quote.content = quoteTextView.text
            quote.createdAt = NSDate()
            var authorString = authorTextField.text! as NSString
            if authorString == "" {
                authorString = "Unknown"
            }
            let lastCharacter = authorString.substringFromIndex(authorString.length - 1)
            if lastCharacter == " " {
                authorString = authorString.substringFromIndex(authorString.length - 1)
            }
            AuthorManager.addAuthor(authorString as String, completion: { (author) -> () in
                quote.author = author
                try! self.moc.save()
                self.navigationController?.popViewControllerAnimated(true)
            })
        } else {
            let alert = UIAlertController(title: "Quote missing", message: "Please enter a quote", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Enter quote here" {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }

    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = "Enter quote here"
            textView.textColor = UIColor(white: 0.8, alpha: 1)
        }
    }

    @IBAction func dismiss(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 9
    }

}
