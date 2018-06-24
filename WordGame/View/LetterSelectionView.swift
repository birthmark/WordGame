//
//  LetterSelectionView.swift
//  WordGame
//
//  Created by xiaog on 2018/6/23.
//  Copyright © 2018年 xiaog. All rights reserved.
//

import UIKit

enum Direction {
    case right
    case left
    case down
    case up
    case leftup
    case leftdown
    case rightup
    case rightdown
}

protocol LetterSelectionDelegate : NSObjectProtocol {
    func selectWordLocation(location: String) -> Bool
}

class LetterSelectionView: UIView {

    var arrLetterViews:Array<LetterView> = Array.init()
    var rows:Int?
    var columns:Int?
    weak var delegate:LetterSelectionDelegate?
    var direction:Direction = .right
    
    var firstLetterView: LetterView?
    var lastLetterView: LetterView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(gameData: Array<Array<String>>) {
        self.removeAllSubviews()
        self.arrLetterViews.removeAll()
        
        rows = gameData.count
        columns = gameData.first?.count
        let itemSize = (kScreenW-CGFloat(columns!)+1) / CGFloat(columns!);
        
        for row in 0..<rows! {
            for column in 0..<columns! {
                let view = LetterView.init(frame: CGRect.zero)
                view.width = itemSize
                view.height = itemSize
                view.left = CGFloat(column) * itemSize + CGFloat(column)
                view.top = CGFloat(row) * itemSize + CGFloat(row)
                view.value = gameData[row][column]
                view.tag = row*rows!+column + kViewTagBase
                addSubview(view)
                arrLetterViews.append(view)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstLetterView = nil
        lastLetterView = nil
        let touch = touches.first!
        let point = touch.location(in: self)
        if let letterView = viewForPoint(point: point) {
            letterView.isSelected = true
            firstLetterView = letterView
            arrLetterViews.append(firstLetterView!)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let point = touch.location(in: self)
        if (self.bounds.contains(point)) {
            if let letterView:LetterView = viewForPoint(point: point) {
//                NSLog("value:\(letterView.value)")
                if (firstLetterView == nil) {
                    firstLetterView = letterView;
                } else {
                    if (letterView != lastLetterView) {
                        lastLetterView = letterView
                        calculateSelectedItems()
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        calculateLocation()
        for item in arrLetterViews {
            item.isSelected = false
        }
        
        for item in arrLetterViews {
            item.isSelected = false
        }
        arrLetterViews.removeAll()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for item in arrLetterViews {
            item.isSelected = false
        }
        
        for item in arrLetterViews {
            item.isSelected = false
        }
        arrLetterViews.removeAll()
    }
    
    private func calculateLocation() {
        var arrLoactions: Array<String> = Array.init()
        
        //sort by tag
        arrLetterViews.sort { (item1, item2) -> Bool in
            return item1.tag < item2.tag
        }
        
        for item in arrLetterViews {
            arrLoactions.append(item.location(columns: columns!))
        }
        
        let location:String = arrLoactions.joined(separator: ",")
        if (delegate?.selectWordLocation(location: location))! {
            for item in arrLetterViews {
                item.isHighlighted = true
            }
        }
    }
    
    private func calculateSelectedItems() {
        let startRow = ((firstLetterView?.tag)!-kViewTagBase) / columns!
        let startColumn = ((firstLetterView?.tag)!-kViewTagBase) % columns!
        let endRow = ((lastLetterView?.tag)!-kViewTagBase) / columns!
        let endColumn = ((lastLetterView?.tag)!-kViewTagBase) % columns!
        
        let (direction, count) = calculateDirectionAndItemCount(startRow: startRow, startColumn: startColumn, endRow: endRow, endColumn: endColumn)
        
//        NSLog("direction:\(direction), count\(count)")
        
        var stepRow = 0;
        var stepColumn = 0;
        
        switch direction {
        case .right:
            stepRow = 0
            stepColumn = 1
        case .left:
            stepRow = 0
            stepColumn = -1
        case .up:
            stepRow = -1
            stepColumn = 0
        case .down:
            stepRow = 1
            stepColumn = 0
        case .leftdown:
            stepRow = 1
            stepColumn = -1
        case .leftup:
            stepRow = -1
            stepColumn = -1
        case .rightup:
            stepRow = -1
            stepColumn = 1
        case .rightdown:
            stepRow = 1
            stepColumn = 1
        }
        
        for item in arrLetterViews {
            item.isSelected = false
        }
        arrLetterViews.removeAll()
        for index in 0..<count {
            let row = ((firstLetterView?.tag)!-kViewTagBase) / columns! + index*stepRow
            let column = ((firstLetterView?.tag)!-kViewTagBase) % columns! + index*stepColumn
            
            if (row >= 0 && row < rows! && column >= 0 && column < columns!) {
                let tag = row * columns! + column + kViewTagBase
//                NSLog("tag:\(tag)")
                
                let view:LetterView = viewWithTag(tag) as! LetterView
                if (!arrLetterViews.contains(view)) {
                    arrLetterViews.append(view)
                    view.isSelected = true
                }
            }
        }
    }
    
    private func calculateDirectionAndItemCount(startRow:Int, startColumn:Int, endRow:Int, endColumn:Int) -> (direction:Direction, count:Int){
        var result:Direction = .right
        if (startRow == endRow && startColumn < endColumn) {
            result = .right
        } else if (startRow == endRow && startColumn > endColumn) {
            result = .left
        } else if (startRow < endRow && startColumn == endColumn) {
            result = .down
        } else if (startRow > endRow && startColumn == endColumn) {
            result = .up
        } else if (startRow < endRow && startColumn > endColumn) {
            result = .leftdown
        } else if (startRow < endRow && startColumn < endColumn) {
            result = .rightdown
        } else if (startRow > endRow && startColumn < endColumn) {
            result = .rightup
        } else if (startRow > endRow && startColumn > endColumn) {
            result = .leftup
        }
        
        let count = max(abs(startRow-endRow), abs(startColumn-endColumn))
        return (result, count+1);
    }
    
    func viewForPoint(point: CGPoint) -> LetterView? {
        for item in subviews {
            if (item.frame.insetBy(dx: 0, dy: 0).contains(point)) {
                return item as? LetterView
            }
        }
        return nil
    }
}
