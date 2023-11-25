//
//  VenueTableViewCell.swift
//  PhonePeProject
//
//  Created by LOVISH on 25/11/23.
//

import UIKit

class VenueTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI(model: Venue?) {
        if let model = model {
            img.image = UIImage(named: "image")
            venueName.text = model.name ?? ""
            venueAddress.text = (model.slug ?? "") + (model.extendedAddress ?? "")
        }
    }
}
