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
       
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
