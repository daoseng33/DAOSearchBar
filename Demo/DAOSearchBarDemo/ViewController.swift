//
//  ViewController.swift
//  DAOSearchBarDemo
//
//  Created by daoseng on 2017/11/11.
//  Copyright © 2017年 likeabossapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var searchBarWithoutDelegate: DAOSearchBar!
    var searchBarWithDelegate: DAOSearchBar!
    var searchBarWithCustomColor: DAOSearchBar!
    
    let innerSpacing: CGFloat = 10.0
    let margin: CGFloat = 15.0
    let searchBarHeight: CGFloat = 34.0
    let searchBarOriginalWidth: CGFloat = 44.0
    var searchBarWidth: CGFloat = 0.0
    var searchBarDestinationFrame = CGRect.zero
    
    // MARK: Setup init values
    
    func setupInitValues () {
        self.view.backgroundColor = UIColor(red: 0.000, green: 0.418, blue: 0.673, alpha: 1.000)
        searchBarWidth = self.view.bounds.width - (2 * margin)
    }
    
    func setupSearchBars() {
        let label1 = UILabel(frame: CGRect(x: margin, y: 80, width: searchBarWidth, height: 21))
        label1.text = "Search bar"
        view.addSubview(label1)
        
        let searchBarWithoutDelegate = DAOSearchBar.init(frame: CGRect(x: margin, y: label1.frame.maxY + innerSpacing, width: searchBarWidth, height: searchBarHeight))
        self.view.addSubview(searchBarWithoutDelegate)
        
        let label2 = UILabel(frame: CGRect(x: margin, y: searchBarWithoutDelegate.frame.maxY + innerSpacing, width: searchBarWidth, height: 21))
        label2.text = "Search bar with delegate"
        view.addSubview(label2)
        
        let searchBarWithDelegate = DAOSearchBar.init(frame: CGRect(x: margin, y: label2.frame.maxY + innerSpacing, width: searchBarOriginalWidth, height: searchBarHeight))
        var frame = searchBarWithDelegate.frame
        frame.size.width = searchBarWidth
        self.searchBarDestinationFrame = frame
        searchBarWithDelegate.delegate = self
        self.view.addSubview(searchBarWithDelegate)
        
        let label3 = UILabel(frame: CGRect(x: margin, y: searchBarWithDelegate.frame.maxY + innerSpacing, width: searchBarWidth, height: 21))
        label3.text = "Search bar with custom color"
        view.addSubview(label3)
        
        let searchBarWithCustomColor = DAOSearchBar.init(frame: CGRect(x: margin, y: label3.frame.maxY + innerSpacing, width: searchBarWidth, height: searchBarHeight))
        searchBarWithCustomColor.searchOffColor = UIColor.orange
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

extension ViewController: DAOSearchBarDelegate {
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
}
