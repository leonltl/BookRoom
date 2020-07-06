//
//  RoomCell.swift
//  BookRoom
//
//  The table cell class that is attached to table in Book A Room scene in Storyboard
//  It is store the level, name, capacity and availability label
//


import UIKit

class RoomCell: UITableViewCell {

    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var capacity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
