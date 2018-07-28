//
//  ViewController.swift
//  DAOSearchBarDemo
//
//  Created by daoseng on 2017/11/11.
//  Copyright © 2017年 likeabossapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DAOSearchBarDelegate {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    let innerSpacing = 10.0
    let margin = 15.0
    let searchBarHeight = 34.0
    let searchBarOriginalWidth = 44.0
    var searchBarWidth = 0.0
    var searchBarDestinationFrame = CGRect.zero
    
    // MARK: SearchBar Delegate
    func destinationFrameForSearchBar(_ searchBar: DAOSearchBar) -> CGRect {
        return self.searchBarDestinationFrame
    }
    
    func searchBar(_ searchBar: DAOSearchBar, willStartTransitioningToState destinationState: DAOSearchBarState) {
        // Do whatever you deem necessary.
    }
    
    func searchBar(_ searchBar: DAOSearchBar, didEndTransitioningFromState previousState: DAOSearchBarState) {
        // Do whatever you deem necessary.
    }
    
    func searchBarDidTapReturn(_ searchBar: DAOSearchBar) {
        // Do whatever you deem necessary.
        // Access the text from the search bar like searchBar.searchField.text
    }
    
    func searchBarTextDidChange(_ searchBar: DAOSearchBar) {
        // Do whatever you deem necessary.
        // Access the text from the search bar like searchBar.searchField.text
    }
    
    // MARK: Setup init values
    
    func setupInitValues () {
        self.view.backgroundColor = UIColor(red: 0.000, green: 0.418, blue: 0.673, alpha: 1.000)
        searchBarWidth = Double(self.view.bounds.width) - (2 * margin)
    }
    
    func setupSearchBars() {
        let searchBarWithoutDelegate = DAOSearchBar.init(frame: CGRect(x: margin, y: Double(self.label1.frame.maxY) + innerSpacing, width: searchBarWidth, height: searchBarHeight))
        self.view.addSubview(searchBarWithoutDelegate)
        
        let searchBarWithDelegate = DAOSearchBar.init(frame: CGRect(x: margin, y: Double(self.label2.frame.maxY) + innerSpacing, width: searchBarOriginalWidth, height: searchBarHeight))
        self.searchBarDestinationFrame = CGRect.init(x: margin, y: Double(self.label2.frame.maxY) + innerSpacing, width: searchBarWidth, height: searchBarHeight)
        searchBarWithDelegate.delegate = self
        self.view.addSubview(searchBarWithDelegate)
        
        let searchBarWithCustomColor = DAOSearchBar.init(frame: CGRect(x: margin, y: Double(self.label3.frame.maxY) + innerSpacing, width: searchBarWidth, height: searchBarHeight))
        searchBarWithCustomColor.searchOffColor = UIColor.darkGray
        searchBarWithCustomColor.searchOnColor = UIColor.white
        searchBarWithCustomColor.searchBarOffColor = UIColor.white
        searchBarWithCustomColor.searchBarOnColor = UIColor.darkGray
        self.view.addSubview(searchBarWithCustomColor)
    }
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitValues()
        setupSearchBars()
    }

}
