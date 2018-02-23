//
//  CKAgendaTableViewCell.swift
//  CKAgendaView
//
//  Created by mk on 2018/2/23.
//

import UIKit

class CKAgendaTableViewCell: UITableViewCell {
    
    let ivImage = UIImageView()
    let lblTitle = UILabel()
    let lblMessage = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.contentMode = .scaleAspectFit
        contentView.addSubview(ivImage)
        
        lblTitle.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        lblTitle.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(lblTitle)
        
        lblMessage.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        lblMessage.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(lblMessage)

        ivImage.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(ivImage.snp.right).offset(8)
            make.right.lessThanOrEqualTo(-15)
            make.top.equalTo(10)
        }
        
        lblMessage.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle)
            make.right.lessThanOrEqualTo(-15)
            make.bottom.equalTo(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
