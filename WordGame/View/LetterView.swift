//
//  LetterView.swift
//  WordGame
//
//  Created by xiaog on 2018/6/23.
//  Copyright © 2018年 xiaog. All rights reserved.
//

import UIKit

class LetterView: UIView {

    var margin:CGFloat = 1
    var isSelected:Bool = false {
        didSet {
            selectView.isHidden = !self.isSelected
            
            setTextColor()
        }
    }
    
    var isHighlighted:Bool = false {
        didSet {
            if (self.isHighlighted) {
                self.backgroundColor = UIColor.color(hexValue: 0xf09e3c)
            } else {
                self.backgroundColor = UIColor.color(hexValue: 0xeeeeee)
            }
            setTextColor()
        }
    }
    
    var value:String? {
        didSet {
            labelChar.text = self.value!
            labelChar.sizeToFit()
            self.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.color(hexValue: 0xeeeeee)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        selectView.width = self.width-margin*2
        selectView.height = self.height-margin*2
        selectView.setCorner(cornerRadius: selectView.width/2)
        selectView.center = CGPoint.init(x: self.width/2, y: self.height/2)
        
        labelChar.center = CGPoint.init(x: self.width/2, y: self.height/2)
    }
    
    func setupViews() {
        self.addSubview(selectView)
        self.addSubview(labelChar)
    }
    
    private lazy var labelChar:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = UIColor.color(hexValue: 0x373737)
        return label
    }()
    
    private lazy var selectView:UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.color(hexValue: 0x4eb2f0)
        view.isHidden = true
        return view
    }()
    
    private func setTextColor() {
        if (self.isSelected || self.isHighlighted) {
            self.labelChar.textColor = UIColor.white
        } else {
            self.labelChar.textColor = UIColor.color(hexValue: 0x373737)
        }
    }
    
    func location(columns:Int) -> String {
        let posX = (self.tag-kViewTagBase) % columns;
        let posY = (self.tag-kViewTagBase) / columns;
        
        return "\(posX),\(posY)"
    }
}
