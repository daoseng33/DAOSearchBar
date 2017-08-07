//
//  ViewController.swift
//  DAOSearchBar
//
//  Created by daoseng on 2017/8/6.
//  Copyright © 2017年 Ray. All rights reserved.
//

import UIKit

class ViewController: UIViewController, INSSearchBarDelegate
{
    let searchBarWithoutDelegate: INSSearchBar = INSSearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 34.0))
    let searchBarWithDelegate: INSSearchBar = INSSearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 34.0))
    let searchBarWithCustomColor: INSSearchBar = INSSearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 34.0))
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(red: 0.000, green: 0.418, blue: 0.673, alpha: 1.000)
        
        let descriptionLabel: UILabel = UILabel(frame: CGRect(x: 20.0, y: 20.0, width: self.view.bounds.size.width - 40.0, height: 20.0))
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        descriptionLabel.text = "Without delegate"
        
        self.view.addSubview(descriptionLabel)
        
        self.searchBarWithoutDelegate.frame = CGRect(x: 20.0, y: 40.0, width: self.view.bounds.width - 40.0, height: 34.0)
        
        self.view.addSubview(self.searchBarWithoutDelegate)
        
        let descriptionLabel2: UILabel = UILabel(frame: CGRect(x: 20.0, y: 120.0, width: self.view.bounds.size.width - 40.0, height: 20.0))
        descriptionLabel2.textColor = UIColor.white
        descriptionLabel2.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        descriptionLabel2.text = "With delegate"
        
        self.view.addSubview(descriptionLabel2)
        
        self.searchBarWithDelegate.frame = CGRect(x: 20.0, y: 140.0, width: 44.0, height: 34.0)
        self.searchBarWithDelegate.delegate = self;
        
        self.view.addSubview(self.searchBarWithDelegate)
        
        let descriptionLabel3: UILabel = UILabel(frame: CGRect(x: 20.0, y: 220.0, width: self.view.bounds.size.width - 40.0, height: 20.0))
        descriptionLabel3.textColor = UIColor.white
        descriptionLabel3.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        descriptionLabel3.text = "Custom color"
        self.view.addSubview(descriptionLabel3)
        
        self.searchBarWithCustomColor.frame = CGRect(x: 20.0, y: 240.0, width: self.view.bounds.width - 40.0, height: 34.0)
        self.searchBarWithCustomColor.searchOffColor = UIColor.darkGray
        self.searchBarWithCustomColor.searchOnColor = UIColor.white
        self.searchBarWithCustomColor.searchBarOnColor = UIColor.darkGray
        self.searchBarWithCustomColor.searchBarOffColor = UIColor.white
        
        self.view.addSubview(self.searchBarWithCustomColor)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func destinationFrameForSearchBar(_ searchBar: INSSearchBar) -> CGRect
    {
        return CGRect(x: 20.0, y: 140.0, width: self.view.bounds.size.width - 40.0, height: 34.0)
    }
    
    func searchBar(_ searchBar: INSSearchBar, willStartTransitioningToState destinationState: INSSearchBarState)
    {
        // Do whatever you deem necessary.
    }
    
    func searchBar(_ searchBar: INSSearchBar, didEndTransitioningFromState previousState: INSSearchBarState)
    {
        // Do whatever you deem necessary.
    }
    
    func searchBarDidTapReturn(_ searchBar: INSSearchBar)
    {
        // Do whatever you deem necessary.
        // Access the text from the search bar like searchBar.searchField.text	
    }
    
    func searchBarTextDidChange(_ searchBar: INSSearchBar)
    {
        // Do whatever you deem necessary.
        // Access the text from the search bar like searchBar.searchField.text
    }
}
