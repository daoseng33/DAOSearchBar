//
//  DAOSearchBar.swift
//  DAOSearchBar
//
//  Created by daoseng on 2017/8/6.
//  Copyright © 2017年 DAO. All rights reserved.
//

import UIKit

/**
 *  The different states for an DAOSearchBarState.
 */

enum DAOSearchBarState: Int {
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

protocol DAOSearchBarDelegate {
    /**
     *  The delegate is asked to provide the destination frame for the search bar when the search bar is transitioning to the visible state.
     *
     *  @param searchBar The search bar that will begin transitioning.
     *
     *  @return The frame in the coordinate system of the search bar's superview.
     */
    
    func destinationFrameForSearchBar(_ searchBar: DAOSearchBar) -> CGRect
    
    /**
     *  The delegate is informed about the imminent state transitioning of the status bar.
     *
     *  @param searchBar        The search bar that will begin transitioning.
     *  @param destinationState The state that the bar will be in once transitioning completes. The current state of the search bar can be queried and will return the state before transitioning.
     */
    
    func searchBar(_ searchBar: DAOSearchBar, willStartTransitioningToState destinationState: DAOSearchBarState)
    
    /**
     *  The delegate is informed about the state transitioning of the status bar that has just occured.
     *
     *  @param searchBar        The search bar that went through state transitioning.
     *  @param destinationState The state that the bar was in before transitioning started. The current state of the search bar can be queried and will return the state after transitioning.
     */
    
    func searchBar(_ searchBar: DAOSearchBar, didEndTransitioningFromState previousState: DAOSearchBarState)
    
    /**
     *  The delegate is informed that the search bar's return key was pressed. This should be used to start querries.
     *
     *  @param searchBar        The search bar whose return key was pressed.
     */
    
    func searchBarDidTapReturn(_ searchBar: DAOSearchBar)
    
    /**
     *  The delegate is informed that the search bar's text has changed.
     *
     *  Important: If the searchField property is explicitly supplied with a delegate property this method will not be called.
     *
     *  @param searchBar        The search bar whose text did change.
     */
    
    func searchBarTextDidChange(_ searchBar: DAOSearchBar)
}

let kDAOSearchBarInset: CGFloat = 11.0
let kDAOSearchBarImageSize: CGFloat = 22.0
let kDAOSearchBarAnimationStepDuration: TimeInterval = 0.25

/**
 *  An animating search bar.
 */

class DAOSearchBar : UIView, UITextFieldDelegate, UIGestureRecognizerDelegate {
    /**
     *  The current state of the search bar.
     */
    
    var state: DAOSearchBarState = DAOSearchBarState.normal
    
    /**
     *  The (optional) delegate is responsible for providing values necessary for state change animations of the search bar. @see DAOSearchBarDelegate.
     */
    
    var delegate: DAOSearchBarDelegate?
    
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
    
    /// The color of the icon image when search bar is not show
    public var searchOffColor = UIColor.white {
        didSet {
            self.searchImageViewOff.tintColor = self.searchOffColor
        }
    }
    
    /// the color of the icon images and the text field text when search bar is show
    public var searchOnColor = UIColor.black {
        didSet {
            self.searchImageViewOn.tintColor = self.searchOnColor
            self.searchImageCrossLeft.tintColor = self.searchOnColor
            self.searchImageCrossRight.tintColor = self.searchOnColor
            self.searchImageCircle.tintColor = self.searchOnColor
            self.searchField.textColor = self.searchOnColor
        }
    }
    
    /// The color of the search bar background when search bar is not show
    public var searchBarOffColor = UIColor.clear {
        didSet {
            if self.state == .normal {
                self.searchFrame.layer.backgroundColor = self.searchBarOffColor.cgColor
            }
        }
    }
    
    /// The color of the search bar background when search bar is show
    public var searchBarOnColor = UIColor.white
    
    // MARK: init
    override init(frame: CGRect) {
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
        self.searchFrame.layer.borderWidth = 1.0
        self.searchFrame.layer.borderColor = UIColor.clear.cgColor
        self.searchFrame.contentMode = UIViewContentMode.redraw
        
        self.addSubview(self.searchFrame)
        
        self.searchField.frame = CGRect(x: kDAOSearchBarInset, y: 3.0, width: self.bounds.width - (2 * kDAOSearchBarInset) - kDAOSearchBarImageSize, height: self.bounds.height - 6.0)
        self.searchField.borderStyle = UITextBorderStyle.none
        self.searchField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.searchField.font = UIFont(name:"AvenirNext-Regular", size:16.0)
        self.searchField.textColor = self.searchOnColor
        self.searchField.alpha = 0.0
        self.searchField.delegate = self
        
        self.searchFrame.addSubview(self.searchField)
        
        let searchImageViewOnContainerView: UIView = UIView(frame:CGRect(x: self.bounds.width - kDAOSearchBarInset - kDAOSearchBarImageSize, y: (self.bounds.height - kDAOSearchBarImageSize) / 2, width: kDAOSearchBarImageSize, height: kDAOSearchBarImageSize))
        searchImageViewOnContainerView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        
        self.searchFrame.addSubview(searchImageViewOnContainerView)
        
        self.searchImageViewOn.frame = searchImageViewOnContainerView.bounds
        self.searchImageViewOn.alpha = 0.0
        self.searchImageViewOn.image = UIImage(named: "NavBarIconSearch")?.withRenderingMode(.alwaysTemplate)
        self.searchImageViewOn.tintColor = self.searchOnColor
        
        searchImageViewOnContainerView.addSubview(self.searchImageViewOn)
        
        self.searchImageCircle.frame = CGRect(x: 0.0, y: 0.0, width: 18.0, height: 18.0)
        self.searchImageCircle.alpha = 0.0
        self.searchImageCircle.image = UIImage(named: "NavBarIconSearchCircle")?.withRenderingMode(.alwaysTemplate)
        self.searchImageCircle.tintColor = self.searchOnColor
        
        searchImageViewOnContainerView.addSubview(self.searchImageCircle)
        
        self.searchImageCrossLeft.frame = CGRect(x: 14.0, y: 14.0, width: 8.0, height: 8.0)
        self.searchImageCrossLeft.alpha = 0.0
        self.searchImageCrossLeft.image = UIImage(named: "NavBarIconSearchBar")?.withRenderingMode(.alwaysTemplate)
        self.searchImageCrossLeft.tintColor = self.searchOnColor
        
        searchImageViewOnContainerView.addSubview(self.searchImageCrossLeft)
        
        self.searchImageCrossRight.frame = CGRect(x: 7.0, y: 7.0, width: 8.0, height: 8.0)
        self.searchImageCrossRight.alpha = 0.0
        self.searchImageCrossRight.image = UIImage(named: "NavBarIconSearchBar2")?.withRenderingMode(.alwaysTemplate)
        self.searchImageCrossRight.tintColor = self.searchOnColor
        
        searchImageViewOnContainerView.addSubview(self.searchImageCrossRight)
        
        self.searchImageViewOff.frame = CGRect(x: self.bounds.width - kDAOSearchBarInset - kDAOSearchBarImageSize, y: (self.bounds.height - kDAOSearchBarImageSize) / 2, width: kDAOSearchBarImageSize, height: kDAOSearchBarImageSize)
        self.searchImageViewOff.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        self.searchImageViewOff.alpha = 1.0
        self.searchImageViewOff.image = UIImage(named: "NavBarIconSearch")?.withRenderingMode(.alwaysTemplate)
        self.searchImageViewOff.tintColor = self.searchOffColor
        
        self.searchFrame.addSubview(self.searchImageViewOff)
        
        let tapableView: UIView = UIView(frame: CGRect(x: self.bounds.width - (2 * kDAOSearchBarInset) - kDAOSearchBarImageSize, y: 0.0, width: (2 * kDAOSearchBarInset) + kDAOSearchBarImageSize, height: self.bounds.height))
        tapableView.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
        tapableView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(DAOSearchBar.changeStateIfPossible(_:))))
        
        self.searchFrame.addSubview(tapableView)
        
        self.keyboardDismissGestureRecognizer.addTarget(self, action: #selector(DAOSearchBar.dismissKeyboard(_:)))
        self.keyboardDismissGestureRecognizer.cancelsTouchesInView = false
        self.keyboardDismissGestureRecognizer.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(DAOSearchBar.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DAOSearchBar.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DAOSearchBar.textDidChange(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: self.searchField)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: self.searchField)
    }
    
    // MARK: animation
    
    @objc func changeStateIfPossible(_ gestureRecognizer: UITapGestureRecognizer) {
        switch self.state {
        case DAOSearchBarState.normal:
            
            self.showSearchBar(gestureRecognizer)
            
        case DAOSearchBarState.searchBarVisible:
            
            self.hideSearchBar(gestureRecognizer)
            
        case DAOSearchBarState.searchBarHasContent:
            
            self.searchField.text = nil
            self.textDidChange(nil)
            
        default:
            
            break
        }
    }
    
    func showSearchBar(_ sender: AnyObject?) {
        if self.state == DAOSearchBarState.normal {
            if let delegate = self.delegate {
                delegate.searchBar(self, willStartTransitioningToState:DAOSearchBarState.searchBarVisible)
            }
            
            self.state = DAOSearchBarState.transitioning
            
            self.searchField.text = nil
            
            UIView.animate(withDuration: kDAOSearchBarAnimationStepDuration, animations: {
                
                self.searchFrame.layer.borderColor = UIColor.white.cgColor
                
                if let delegate = self.delegate {
                    self.originalFrame = self.frame
                    self.frame = delegate.destinationFrameForSearchBar(self)
                }
            }, completion: { (finished: Bool) in
                
                self.searchField.becomeFirstResponder()
                
                UIView.animate(withDuration: kDAOSearchBarAnimationStepDuration * 2, animations: {
                    
                    self.searchFrame.layer.backgroundColor = self.searchBarOnColor.cgColor
                    self.searchImageViewOff.alpha = 0.0
                    self.searchImageViewOn.alpha = 1.0
                    self.searchField.alpha = 1.0
                    
                }, completion: { (finished: Bool) in
                    
                    self.state = DAOSearchBarState.searchBarVisible
                    
                    if let delegate = self.delegate {
                        delegate.searchBar(self, didEndTransitioningFromState: DAOSearchBarState.normal)
                    }
                })
            })
        }
    }
    
    func hideSearchBar(_ sender: AnyObject?) {
        if self.state == DAOSearchBarState.searchBarVisible || self.state == DAOSearchBarState.searchBarHasContent {
            self.window?.endEditing(true)
            
            if let delegate = self.delegate {
                delegate.searchBar(self, willStartTransitioningToState: DAOSearchBarState.normal)
            }
            
            self.searchField.text = nil
            
            self.state = DAOSearchBarState.transitioning
            
            UIView.animate(withDuration: kDAOSearchBarAnimationStepDuration, animations: {
                
                if self.delegate != nil {
                    self.frame = self.originalFrame
                }
                
                self.searchFrame.layer.backgroundColor = self.searchBarOffColor.cgColor
                self.searchImageViewOff.alpha = 1.0
                self.searchImageViewOn.alpha = 0.0
                self.searchField.alpha = 0.0
                
            }, completion: { (finished: Bool) in
                
                UIView.animate(withDuration: kDAOSearchBarAnimationStepDuration * 2, animations: {
                    
                    self.searchFrame.layer.borderColor = UIColor.clear.cgColor
                    
                }, completion: { (finished: Bool) in
                    
                    self.searchImageCircle.frame = CGRect(x: 0.0, y: 0.0, width: 18.0, height: 18.0)
                    self.searchImageCrossLeft.frame = CGRect(x: 14.0, y: 14.0, width: 8.0, height: 8.0)
                    self.searchImageCircle.alpha = 0.0
                    self.searchImageCrossLeft.alpha = 0.0
                    self.searchImageCrossRight.alpha = 0.0
                    
                    self.state = DAOSearchBarState.normal;
                    
                    if let delegate = self.delegate {
                        delegate.searchBar(self, didEndTransitioningFromState: DAOSearchBarState.searchBarVisible)
                    }
                })
            })
        }
    }
    
    // MARK: text filed
    
    @objc func textDidChange(_ notification: Notification?) {
        let hasText: Bool = self.searchField.text!.count != 0
        
        if hasText {
            if self.state == DAOSearchBarState.searchBarVisible {
                
                self.state = DAOSearchBarState.transitioning;
                
                self.searchImageViewOn.alpha = 0.0
                self.searchImageCircle.alpha = 1.0
                self.searchImageCrossLeft.alpha = 1.0
                
                UIView.animate(withDuration: kDAOSearchBarAnimationStepDuration, animations: {
                    
                    self.searchImageCircle.frame = CGRect(x: 2.0, y: 2.0, width: 18.0, height: 18.0)
                    self.searchImageCrossLeft.frame = CGRect(x: 7.0, y: 7.0, width: 8.0, height: 8.0)
                    
                }, completion: { (finished: Bool) in
                    
                    UIView.animate(withDuration: kDAOSearchBarAnimationStepDuration, animations: {
                        
                        self.searchImageCrossRight.alpha = 1.0
                        
                    }, completion: { (finished: Bool) in
                        
                        self.state = DAOSearchBarState.searchBarHasContent
                    })
                })
            }
        }
        else {
            if self.state == DAOSearchBarState.searchBarHasContent {
                
                self.state = DAOSearchBarState.transitioning;
                
                UIView.animate(withDuration: kDAOSearchBarAnimationStepDuration, animations: {
                    
                    self.searchImageCrossRight.alpha = 0.0
                    
                }, completion: { (finished: Bool) in
                    
                    UIView.animate(withDuration: kDAOSearchBarAnimationStepDuration, animations: {
                        
                        self.searchImageCircle.frame = CGRect(x: 0.0, y: 0.0, width: 18.0, height: 18.0)
                        self.searchImageCrossLeft.frame = CGRect(x: 14.0, y: 14.0, width: 8.0, height: 8.0)
                        
                    }, completion: { (finished: Bool) in
                        
                        self.searchImageViewOn.alpha = 1.0
                        self.searchImageCircle.alpha = 0.0
                        self.searchImageCrossLeft.alpha = 0.0
                        
                        self.state = DAOSearchBarState.searchBarVisible
                    })
                })
            }
        }
        
        if let delegate = self.delegate {
            delegate.searchBarTextDidChange(self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let retVal: Bool = true;
        
        if let delegate = self.delegate {
            delegate.searchBarDidTapReturn(self)
        }
        
        return retVal
    }
    
    // MARK: keyboard
    
    @objc func keyboardWillShow(_ notification: Notification?) {
        if self.searchField.isFirstResponder {
            self.window?.rootViewController?.view.addGestureRecognizer(self.keyboardDismissGestureRecognizer)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification?) {
        if self.searchField.isFirstResponder {
            self.window?.rootViewController?.view.addGestureRecognizer(self.keyboardDismissGestureRecognizer)
        }
    }
    
    @objc func dismissKeyboard(_ gestureRecognizer: UITapGestureRecognizer) {
        if (self.searchField.isFirstResponder) {
            self.window?.endEditing(true)
            if (self.state == DAOSearchBarState.searchBarVisible && self.searchField.text!.count == 0)
            {
                self.hideSearchBar(nil)
            }
        }
    }
    
    // MARK: gesture
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var retVal: Bool = true
        
        if self.bounds.contains(touch.location(in: self)) {
            retVal = false
        }
        
        return retVal
    }
}

