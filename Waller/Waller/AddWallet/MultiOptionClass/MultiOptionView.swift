//
//  MultiOptionView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 06/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

protocol MultiOptionViewDelegate {
    
    func optionSelected(selectedIndex:Int)
}

class MultiOptionView: UIView, OptionViewDelegate {

    var options:[OptionView] = []
    var selectedIndex:Int = 0
    var delegate:MultiOptionViewDelegate!
    
    init(frame: CGRect, data:[Option])
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        var totalHeight:CGFloat = 0

        for index in 0...data.count-1
        {
            let pageFrame = CGRect.init(x: 0, y: totalHeight, width: frame.size.width, height:0)
            let option = OptionView.init(frame: pageFrame, data: data[index], index: index)
            option.delegate = self
            
            self.addSubview(option)
            options.append(option)
            
            totalHeight = totalHeight + option.frame.size.height + CGFloat(Props.selectionMargin)
        }
        self.frame.size.height = totalHeight - CGFloat(Props.selectionMargin)
        
        
    }
    
    func optionButtonSelected(selectedIndex: Int) {

        guard let _ = self.delegate?.optionSelected(selectedIndex: selectedIndex)
        else { return }
    }
    
    func optionButtonPressed(pressedIndex:Int) {
        
        openOption(optionIndex: pressedIndex, animated: true)
        
        /*
        var y:CGFloat = 0
        for index in 0...options.count-1
        {
            var height:CGFloat = 0
            let thisOption = options[index]
            if thisOption.index == pressedIndex
            {
                // set opened height
                height = thisOption.height
            }
            else
            {
                // set closed height
                height = CGFloat(Props.selectionClosedSize)
            }
            
            UIView.animate(withDuration: 1, animations:
            {
                thisOption.frame.size.height = height
                thisOption.frame.origin.y = y
            })
            
            y = y + thisOption.frame.size.height + CGFloat(Props.selectionMargin)
        }
         */
        
        /*
        if selectedIndex != pressedIndex
        {
            selectedIndex = pressedIndex
            print("Pressed option w index \(pressedIndex)")
        }
        
        let selectedOption = options[pressedIndex]
        if selectedOption.isOpen == false
        {
            UIView.animate(withDuration: 1, animations: {
                
                selectedOption.frame.size.height = selectedOption.height
            })
        }
        
        for option in options
        {
            if option != selectedOption
            {
                UIView.animate(withDuration: 1, animations: {
                
                    option.frame.size.height = 30
                })
            }
        }
    
        var y:CGFloat = 0
        
        for index in 0...options.count-1 {
            
            let thisOption = options[index]
            
            thisOption.frame.origin.y = y
            
            UIView.animate(withDuration: 1, animations:
            {
                thisOption.frame.origin.y = y
            })
            
            y = y + thisOption.frame.size.height
        }
         */
    }
    
    func setDefaultIndex(index:Int)
    {
        openOption(optionIndex: index, animated: false)
    }
    
    func openOption(optionIndex:Int,animated:Bool)
    {
        var y:CGFloat = 0
        var totalHeight:CGFloat = 0
        for index in 0...options.count-1
        {
            var height:CGFloat = 0
            let thisOption = options[index]
            if thisOption.index == optionIndex
            {
                // set opened height
                height = thisOption.height
            }
            else
            {
                // set closed height
                height = CGFloat(Props.selectionClosedSize)
            }
            
            if animated == true
            {
                UIView.animate(withDuration: 1, animations:
                {
                    thisOption.frame.size.height = height
                    thisOption.frame.origin.y = y
                })
            }
            else
            {
                thisOption.frame.size.height = height
                thisOption.frame.origin.y = y
            }
            
            totalHeight = totalHeight + height + CGFloat(Props.optionViewMargin * index) + 10
            
            y = y + thisOption.frame.size.height + CGFloat(Props.selectionMargin)
        }
        
        self.frame = CGRect.init(x: frame.origin.x , y: frame.origin.y, width: frame.size.width, height: totalHeight)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

}
