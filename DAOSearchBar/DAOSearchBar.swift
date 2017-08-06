//
//  DAOSearchBar.swift
//  DAOSearchBar
//
//  Created by daoseng on 2017/8/6.
//  Copyright © 2017年 Ray. All rights reserved.
//

import UIKit

/**
 *  The different states for an INSSearchBarState.
 */

enum INSSearchBarState: Int
{
    /**
     *  The default or normal state. The search field is hidden.
     */
    
    case normal
    
    /**
     *  The state where the search field is visible.
     */
    
    case searchBarVisible
    
    /**
     *  The state where the search field is visible and there is text entered.
     */
    
    case searchBarHasContent
    
    /**
     *  The search bar is transitioning between states.
     */
    
    case transitioning
}

/**
 *  The delegate is responsible for providing values to the search bar that it can use to determine its size.
 */

protocol INSSearchBarDelegate
{
    /**
     *  The delegate is asked to provide the destination frame for the search bar when the search bar is transitioning to the visible state.
     *
     *  @param searchBar The search bar that will begin transitioning.
     *
     *  @return The frame in the coordinate system of the search bar's superview.
     */
    
    func destinationFrameForSearchBar(_ searchBar: INSSearchBar) -> CGRect
    
    /**
     *  The delegate is informed about the imminent state transitioning of the status bar.
     *
     *  @param searchBar        The search bar that will begin transitioning.
     *  @param destinationState The state that the bar will be in once transitioning completes. The current state of the search bar can be queried and will return the state before transitioning.
     */
    
    func searchBar(_ searchBar: INSSearchBar, willStartTransitioningToState destinationState: INSSearchBarState)
    
    /**
     *  The delegate is informed about the state transitioning of the status bar that has just occured.
     *
     *  @param searchBar        The search bar that went through state transitioning.
     *  @param destinationState The state that the bar was in before transitioning started. The current state of the search bar can be queried and will return the state after transitioning.
     */
    
    func searchBar(_ searchBar: INSSearchBar, didEndTransitioningFromState previousState: INSSearchBarState)
    
    /**
     *  The delegate is informed that the search bar's return key was pressed. This should be used to start querries.
     *
     *  @param searchBar        The search bar whose return key was pressed.
     */
    
    func searchBarDidTapReturn(_ searchBar: INSSearchBar)
    
    /**
     *  The delegate is informed that the search bar's text has changed.
     *
     *  Important: If the searchField property is explicitly supplied with a delegate property this method will not be called.
     *
     *  @param searchBar        The search bar whose text did change.
     */
    
    func searchBarTextDidChange(_ searchBar: INSSearchBar)
}

let kINSSearchBarInset: CGFloat = 11.0
let kINSSearchBarImageSize: CGFloat = 22.0
let kINSSearchBarAnimationStepDuration: TimeInterval = 0.25

/**
 *  An animating search bar.
 */

class INSSearchBar : UIView, UITextFieldDelegate, UIGestureRecognizerDelegate
{
    /**
     *  The current state of the search bar.
     */
    
    var state: INSSearchBarState = INSSearchBarState.normal
    
    /**
     *  The (optional) delegate is responsible for providing values necessary for state change animations of the search bar. @see INSSearchBarDelegate.
     */
    
    var delegate: INSSearchBarDelegate?
    
    /**
     *  The borderedframe of the search bar. Visible only when search mode is active.
     */
    
    let searchFrame: UIView
    
    /**
     *  The text field used for entering search queries. Visible only when search is active.
     */
    
    let searchField: UITextField
    
    /**
     *  The image view containing the search magnifying glass icon in white. Visible when search is not active.
     */
    
    let searchImageViewOff: UIImageView
    
    /**
     *  The image view containing the search magnifying glass icon in blue. Visible when search is active.
     */
    
    let searchImageViewOn: UIImageView
    
    /**
     *  The image view containing the circle part of the magnifying glass icon in blue.
     */
    
    let searchImageCircle: UIImageView
    
    /**
     *  The image view containing the left cross part of the magnifying glass icon in blue.
     */
    
    let searchImageCrossLeft: UIImageView
    
    /**
     *  The image view containing the right cross part of the magnifying glass icon in blue.
     */
    
    let searchImageCrossRight: UIImageView
    
    /**
     *  A gesture recognizer responsible for closing the keyboard once tapped on.
     *
     *	Added to the window's root view controller view and set to allow touches to propagate to that view.
     */
    
    let keyboardDismissGestureRecognizer: UITapGestureRecognizer
    
    /**
     *  The frame of the search bar before a transition started. Only set if delegate is not nil.
     */
    var originalFrame: CGRect
    
    override init(frame: CGRect)
    {
        self.searchFrame = UIView(frame: CGRect.zero)
        self.searchField = UITextField(frame: CGRect.zero)
        self.searchImageViewOff = UIImageView(frame: CGRect.zero)
        self.searchImageViewOn = UIImageView(frame: CGRect.zero)
        self.searchImageCircle = UIImageView(frame: CGRect.zero)
        self.searchImageCrossLeft = UIImageView(frame: CGRect.zero)
        self.searchImageCrossRight = UIImageView(frame: CGRect.zero)
        self.keyboardDismissGestureRecognizer = UITapGestureRecognizer()
        self.originalFrame = CGRect.zero
        
        super.init(frame: frame)
        
        self.isOpaque = false
        self.backgroundColor = UIColor.clear
        
        self.searchFrame.frame = self.bounds
        self.searchFrame.isOpaque = false
        self.searchFrame.backgroundColor = UIColor.clear
        self.searchFrame.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.searchFrame.layer.masksToBounds = true
        self.searchFrame.layer.cornerRadius = self.bounds.height / 2
        self.searchFrame.layer.borderWidth = 0.5
        self.searchFrame.layer.borderColor = UIColor.clear.cgColor
        self.searchFrame.contentMode = UIViewContentMode.redraw
        
        self.addSubview(self.searchFrame)
        
        self.searchField.frame = CGRect(x: kINSSearchBarInset, y: 3.0, width: self.bounds.width - (2 * kINSSearchBarInset) - kINSSearchBarImageSize, height: self.bounds.height - 6.0)
        self.searchField.borderStyle = UITextBorderStyle.none
        self.searchField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.searchField.font = UIFont(name:"AvenirNext-Regular", size:16.0)
        self.searchField.textColor = UIColor(red: 17.0/255.0, green: 190.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        self.searchField.alpha = 0.0
        self.searchField.delegate = self
        
        self.searchFrame.addSubview(self.searchField)
        
        let searchImageViewOnContainerView: UIView = UIView(frame:CGRect(x: self.bounds.width - kINSSearchBarInset - kINSSearchBarImageSize, y: (self.bounds.height - kINSSearchBarImageSize) / 2, width: kINSSearchBarImageSize, height: kINSSearchBarImageSize))
        searchImageViewOnContainerView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        
        self.searchFrame.addSubview(searchImageViewOnContainerView)
        
        self.searchImageViewOn.frame = searchImageViewOnContainerView.bounds
        self.searchImageViewOn.alpha = 0.0
        self.searchImageViewOn.image = UIImage(named: "NavBarIconSearch_black")
        
        searchImageViewOnContainerView.addSubview(self.searchImageViewOn)
        
        self.searchImageCircle.frame = CGRect(x: 0.0, y: 0.0, width: 18.0, height: 18.0)
        self.searchImageCircle.alpha = 0.0
        self.searchImageCircle.image = UIImage(named: "NavBarIconSearchCircle_black")
        
        searchImageViewOnContainerView.addSubview(self.searchImageCircle)
        
        self.searchImageCrossLeft.frame = CGRect(x: 14.0, y: 14.0, width: 8.0, height: 8.0)
        self.searchImageCrossLeft.alpha = 0.0
        self.searchImageCrossLeft.image = UIImage(named: "NavBarIconSearchBar_black")
        
        searchImageViewOnContainerView.addSubview(self.searchImageCrossLeft)
        
        self.searchImageCrossRight.frame = CGRect(x: 7.0, y: 7.0, width: 8.0, height: 8.0)
        self.searchImageCrossRight.alpha = 0.0
        self.searchImageCrossRight.image = UIImage(named: "NavBarIconSearchBar2_black")
        
        searchImageViewOnContainerView.addSubview(self.searchImageCrossRight)
        
        self.searchImageViewOff.frame = CGRect(x: self.bounds.width - kINSSearchBarInset - kINSSearchBarImageSize, y: (self.bounds.height - kINSSearchBarImageSize) / 2, width: kINSSearchBarImageSize, height: kINSSearchBarImageSize)
        self.searchImageViewOff.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        self.searchImageViewOff.alpha = 1.0
        self.searchImageViewOff.image = UIImage(named: "NavBarIconSearch_white")
        
        self.searchFrame.addSubview(self.searchImageViewOff)
        
        let tapableView: UIView = UIView(frame: CGRect(x: self.bounds.width - (2 * kINSSearchBarInset) - kINSSearchBarImageSize, y: 0.0, width: (2 * kINSSearchBarInset) + kINSSearchBarImageSize, height: self.bounds.height))
        tapableView.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
        tapableView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(INSSearchBar.changeStateIfPossible(_:))))
        
        self.searchFrame.addSubview(tapableView)
        
        self.keyboardDismissGestureRecognizer.addTarget(self, action: #selector(INSSearchBar.dismissKeyboard(_:)))
        self.keyboardDismissGestureRecognizer.cancelsTouchesInView = false
        self.keyboardDismissGestureRecognizer.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(INSSearchBar.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(INSSearchBar.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UITextInputDelegate.textDidChange(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: self.searchField)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: self.searchField)
    }
    
    func changeStateIfPossible(_ gestureRecognizer: UITapGestureRecognizer)
    {
        switch self.state
        {
        case INSSearchBarState.normal:
            
            self.showSearchBar(gestureRecognizer)
            
        case INSSearchBarState.searchBarVisible:
            
            self.hideSearchBar(gestureRecognizer)
            
        case INSSearchBarState.searchBarHasContent:
            
            self.searchField.text = nil
            self.textDidChange(nil)
            
        default:
            
            break
        }
    }
    
    func dismissKeyboard(_ gestureRecognizer: UITapGestureRecognizer)
    {
        if (self.searchField.isFirstResponder)
        {
            self.window?.endEditing(true)
            if (self.state == INSSearchBarState.searchBarVisible && self.searchField.text!.characters.count == 0)
            {
                self.hideSearchBar(nil)
            }
        }
    }
    
    func showSearchBar(_ sender: AnyObject?)
    {
        if self.state == INSSearchBarState.normal
        {
            if let delegate = self.delegate
            {
                delegate.searchBar(self, willStartTransitioningToState:INSSearchBarState.searchBarVisible)
            }
            
            self.state = INSSearchBarState.transitioning
            
            self.searchField.text = nil
            
            UIView.animate(withDuration: kINSSearchBarAnimationStepDuration, animations: {
                
                self.searchFrame.layer.borderColor = UIColor.white.cgColor
                
                if let delegate = self.delegate
                {
                    self.originalFrame = self.frame
                    self.frame = delegate.destinationFrameForSearchBar(self)
                }
            }, completion: { (finished: Bool) in
                
                self.searchField.becomeFirstResponder()
                
                UIView.animate(withDuration: kINSSearchBarAnimationStepDuration * 2, animations: {
                    
                    self.searchFrame.layer.backgroundColor = UIColor.white.cgColor
                    self.searchImageViewOff.alpha = 0.0
                    self.searchImageViewOn.alpha = 1.0
                    self.searchField.alpha = 1.0
                    
                }, completion: { (finished: Bool) in
                    
                    self.state = INSSearchBarState.searchBarVisible
                    
                    if let delegate = self.delegate
                    {
                        delegate.searchBar(self, didEndTransitioningFromState: INSSearchBarState.normal)
                    }
                })
            })
        }
    }
    
    func hideSearchBar(_ sender: AnyObject?)
    {
        if self.state == INSSearchBarState.searchBarVisible || self.state == INSSearchBarState.searchBarHasContent
        {
            self.window?.endEditing(true)
            
            if let delegate = self.delegate
            {
                delegate.searchBar(self, willStartTransitioningToState: INSSearchBarState.normal)
            }
            
            self.searchField.text = nil
            
            self.state = INSSearchBarState.transitioning
            
            UIView.animate(withDuration: kINSSearchBarAnimationStepDuration, animations: {
                
                if self.delegate != nil
                {
                    self.frame = self.originalFrame
                }
                
                self.searchFrame.layer.backgroundColor = UIColor.clear.cgColor
                self.searchImageViewOff.alpha = 1.0
                self.searchImageViewOn.alpha = 0.0
                self.searchField.alpha = 0.0
                
            }, completion: { (finished: Bool) in
                
                UIView.animate(withDuration: kINSSearchBarAnimationStepDuration * 2, animations: {
                    
                    self.searchFrame.layer.borderColor = UIColor.clear.cgColor
                    
                }, completion: { (finished: Bool) in
                    
                    self.searchImageCircle.frame = CGRect(x: 0.0, y: 0.0, width: 18.0, height: 18.0)
                    self.searchImageCrossLeft.frame = CGRect(x: 14.0, y: 14.0, width: 8.0, height: 8.0)
                    self.searchImageCircle.alpha = 0.0
                    self.searchImageCrossLeft.alpha = 0.0
                    self.searchImageCrossRight.alpha = 0.0
                    
                    self.state = INSSearchBarState.normal;
                    
                    if let delegate = self.delegate
                    {
                        delegate.searchBar(self, didEndTransitioningFromState: INSSearchBarState.searchBarVisible)
                    }
                })
            })
        }
    }
    
    func textDidChange(_ notification: Notification?)
    {
        let hasText: Bool = self.searchField.text!.characters.count != 0
        
        if hasText
        {
            if self.state == INSSearchBarState.searchBarVisible
            {
                
                self.state = INSSearchBarState.transitioning;
                
                self.searchImageViewOn.alpha = 0.0
                self.searchImageCircle.alpha = 1.0
                self.searchImageCrossLeft.alpha = 1.0
                
                UIView.animate(withDuration: kINSSearchBarAnimationStepDuration, animations: {
                    
                    self.searchImageCircle.frame = CGRect(x: 2.0, y: 2.0, width: 18.0, height: 18.0)
                    self.searchImageCrossLeft.frame = CGRect(x: 7.0, y: 7.0, width: 8.0, height: 8.0)
                    
                }, completion: { (finished: Bool) in
                    
                    UIView.animate(withDuration: kINSSearchBarAnimationStepDuration, animations: {
                        
                        self.searchImageCrossRight.alpha = 1.0
                        
                    }, completion: { (finished: Bool) in
                        
                        self.state = INSSearchBarState.searchBarHasContent
                    })
                })
            }
        }
        else
        {
            if self.state == INSSearchBarState.searchBarHasContent
            {
                
                self.state = INSSearchBarState.transitioning;
                
                UIView.animate(withDuration: kINSSearchBarAnimationStepDuration, animations: {
                    
                    self.searchImageCrossRight.alpha = 0.0
                    
                }, completion: { (finished: Bool) in
                    
                    UIView.animate(withDuration: kINSSearchBarAnimationStepDuration, animations: {
                        
                        self.searchImageCircle.frame = CGRect(x: 0.0, y: 0.0, width: 18.0, height: 18.0)
                        self.searchImageCrossLeft.frame = CGRect(x: 14.0, y: 14.0, width: 8.0, height: 8.0)
                        
                    }, completion: { (finished: Bool) in
                        
                        self.searchImageViewOn.alpha = 1.0
                        self.searchImageCircle.alpha = 0.0
                        self.searchImageCrossLeft.alpha = 0.0
                        
                        self.state = INSSearchBarState.searchBarVisible
                    })
                })
            }
        }
        
        if let delegate = self.delegate
        {
            delegate.searchBarTextDidChange(self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let retVal: Bool = true;
        
        if let delegate = self.delegate
        {
            delegate.searchBarDidTapReturn(self)
        }
        
        return retVal
    }
    
    func keyboardWillShow(_ notification: Notification?)
    {
        if self.searchField.isFirstResponder
        {
            self.window?.rootViewController?.view.addGestureRecognizer(self.keyboardDismissGestureRecognizer)
        }
    }
    
    func keyboardWillHide(_ notification: Notification?)
    {
        if self.searchField.isFirstResponder
        {
            self.window?.rootViewController?.view.addGestureRecognizer(self.keyboardDismissGestureRecognizer)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        var retVal: Bool = true
        
        if self.bounds.contains(touch.location(in: self))
        {
            retVal = false
        }
        
        return retVal
    }
}

