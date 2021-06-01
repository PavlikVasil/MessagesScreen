//
//  MessageTableViewCell.swift
//  MessagesScreen
//
//  Created by Павел on 01.06.2021.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(
      name: String?,
      messageText: String?,
      dateString: String?,
      imageUrlString: String?)
    {
        if imageUrlString == ""{
            personImageView.image = UIImage(named: "Image")
        } else {
            if let imageUrl = (URL(string: imageUrlString!)){
                personImageView.kf.setImage(with: imageUrl)
            }
        }
        
      personNameLabel.text = name
      messageTextLabel.text = messageText
      dateLabel.text = getFormattedDate(from: dateString)
      personImageView.layer.cornerRadius = personImageView.frame.height / 2
      
    }
    
    private func getFormattedDate(from dateString: String?) -> String? {
        let dateFormatter = ISO8601DateFormatter()
        let calendar = Calendar.current
        let date = dateFormatter.date(from: dateString ?? "") ?? Date()
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMMM yy"
        
        if Calendar.current.isDateInToday(date) {
          dateFormatterPrint.dateFormat = "HH:mm"
          return dateFormatterPrint.string(from: date)
        }
        if calendar.isDateInYesterday(date) {
          return "Yesterday"
        }
        
        return dateFormatterPrint.string(from: date)
    }

}
