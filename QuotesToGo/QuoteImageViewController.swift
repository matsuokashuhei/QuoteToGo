//
//  QuoteImageViewController.swift
//  QuotesToGo
//


import UIKit

class QuoteImageViewController: UIViewController {

    @IBOutlet weak var quiteImageView: UIImageView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    var quoteText: String!
    var author: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        createQuoteImage()
    }

    func createQuoteImage() {
        imageLoadingIndicator.startAnimating()
        let randomImageIndex = Int(arc4random_uniform(UInt32(45))) + 1
        let URL = NSURL(string: "http://www.daniel-autenrieth.de/quotesToGo/\(randomImageIndex).jpg")!
        getDataFromURL(URL) { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                guard let data = data where error == nil else {
                    return
                }
                self.shareButton.enabled = true
                self.saveButton.enabled = true
                let quoteImage = NSBundle.mainBundle().loadNibNamed("QuoteShareImageView", owner: self, options: nil).last as! QuoteImageView
                quoteImage.backgroundImage.image = UIImage(data: data)
                quoteImage.quoteTextView.text = self.quoteText
                quoteImage.authorLabel.text = self.author

                UIGraphicsBeginImageContextWithOptions(quoteImage.bounds.size, true, 0)
                let context = UIGraphicsGetCurrentContext()
                quoteImage.layer.renderInContext(context!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                let imageData = UIImageJPEGRepresentation(image, 0.5)
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.quiteImageView.alpha = 0
                    }, completion: { (success) -> Void in
                        self.quiteImageView.image = UIImage(data: imageData!)
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
                            self.imageLoadingIndicator.alpha = 0
                            self.imageLoadingIndicator.stopAnimating()
                            self.quiteImageView.alpha = 1
                        })
                })
                /*
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.quiteImageView.alpha = 0
                    }, completion: { (success) -> Void in
                })
                */
            })
        }
    }

    func getDataFromURL(URL: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(URL) { (data, response, error) -> Void in
            completion(data: data, response: response, error: error)
        }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveToCameraRoll(sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(quiteImageView.image!, nil, nil, nil)
    }

    @IBAction func shareQuote(sender: AnyObject) {
        let quoteString = "\"\(quoteText)\" - \(author)"
        let quoteImage = quiteImageView.image!
        let activityController = UIActivityViewController(activityItems: [quoteImage, quoteString], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }

    @IBAction func dismiss(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
