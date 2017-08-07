# DAOSearchBar
DAOSearchBar is based on INSSearchBar: https://github.com/berlininsomniac/INSSearchBar_Swift

It is a 3rd-party search bar with beautiful animation. Unfortunately, it seems like INSSearchBar is no longer update anymore.

So, heres the DAOSearchBar.

![withoutDelegate](https://media.giphy.com/media/3o6vXWksaIn9OFF78I/giphy.gif)
![withDelegate](https://media.giphy.com/media/NEquunOmZLUv6/giphy.gif)
![customColor](https://media.giphy.com/media/EGECl0ncJTUME/giphy.gif)

### What's new in version 1.0.1 ###
Now you can custom the search bar background and the magnifier icon color!

## Installation ##
### CocoaPods ###
```
pod 'DAOSearchBar', '~> 1.0.1'
```
## Usage ##
### Search bar without delegate ###
```swift
self.searchBarWithoutDelegate.frame = CGRect(x: 20.0, y: 40.0, width: self.view.bounds.width - 40.0, height: 34.0)
self.view.addSubview(self.searchBarWithoutDelegate)
```

### Searcg bar with delegate ###
```swift
class ViewController: UIViewController, INSSearchBarDelegate {}
```

```swift
self.searchBarWithDelegate.frame = CGRect(x: 20.0, y: 140.0, width: 44.0, height: 34.0)
self.searchBarWithDelegate.delegate = self;
self.view.addSubview(self.searchBarWithDelegate)
```

### Custom color ###
```swift
self.searchBarWithCustomColor.searchOffColor = UIColor.darkGray
self.searchBarWithCustomColor.searchOnColor = UIColor.white
self.searchBarWithCustomColor.searchBarOffColor = UIColor.white
self.searchBarWithCustomColor.searchBarOnColor = UIColor.darkGray
```

### Delegate ###
```swift
func destinationFrameForSearchBar(_ searchBar: INSSearchBar) -> CGRect
    {
        return CGRect(x: 20.0, y: 140.0, width: self.view.bounds.size.width - 40.0, height: 34.0)
    }
 ```
 ```swift
 func searchBar(_ searchBar: INSSearchBar, willStartTransitioningToState destinationState: INSSearchBarState)
    {
        // Do whatever you deem necessary.
    }
 ```
 ```swift
 func searchBar(_ searchBar: INSSearchBar, didEndTransitioningFromState previousState: INSSearchBarState)
    {
        // Do whatever you deem necessary.
    }
 ```
 ```swift
 func searchBarDidTapReturn(_ searchBar: INSSearchBar)
    {
        // Do whatever you deem necessary.
        // Access the text from the search bar like searchBar.searchField.text	
    }
 ```
 ```swift
 func searchBarTextDidChange(_ searchBar: INSSearchBar)
    {
        // Do whatever you deem necessary.
        // Access the text from the search bar like searchBar.searchField.text
    }
 ```
 
