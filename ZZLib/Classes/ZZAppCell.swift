//
//  ZZAppCell.swift
//  ZZLib
//
//  Created by 张忠 on 2019/1/9.
//

import UIKit

public class ZZAppCell: UITableViewCell {
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configWith(app:ZZApp,bundle:Bundle) {
        iconIV.image = app.appIcon(bundle: bundle)
        iconIV.layer.cornerRadius = 8.0
        iconIV.layer.masksToBounds = true
        self.titleLabel.text = app.appTitle()
        self.detailLabel.text = app.appDescription()
        self.accessoryType = .disclosureIndicator
    }
}
