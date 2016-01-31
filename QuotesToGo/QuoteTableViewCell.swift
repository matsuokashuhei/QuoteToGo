//
//  QuoteTableViewCell.swift
//  QuotesToGo
//


import UIKit

class QuoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var quoteLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        ImageMasker.maskImage(authorImageView, size: CGSize(width: 54, height: 54))
        if UIScreen.mainScreen().bounds.size.width <= 320 {
            quoteLabelWidthConstraint.constant = 270
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
