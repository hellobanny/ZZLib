# ZZLib

这个只是个为个人使用方便的一些Swift代码和MoreApp的一些功能，不具备广泛的实用性，只是可以作为他们的参考。

[![CI Status](http://img.shields.io/travis/张忠/ZZLib.svg?style=flat)](https://travis-ci.org/张忠/ZZLib)
[![Version](https://img.shields.io/cocoapods/v/ZZLib.svg?style=flat)](http://cocoapods.org/pods/ZZLib)
[![License](https://img.shields.io/cocoapods/l/ZZLib.svg?style=flat)](http://cocoapods.org/pods/ZZLib)
[![Platform](https://img.shields.io/cocoapods/p/ZZLib.svg?style=flat)](http://cocoapods.org/pods/ZZLib)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ZZLib is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZZLib', :git => 'https://github.com/hellobanny/ZZLib.git'
```

## 配置例子
里面的网站使用了http，需要加这个权限控制

```
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSAllowsArbitraryLoads</key>
	<true/>
	<key>NSExceptionDomains</key>
	<dict>
		<key>appby.us</key>
		<string></string>
	</dict>
</dict>
```

定义开始的Section

```
let StartSection = 1
```

初始化

```
override func viewDidLoad() {
   super.viewDidLoad()
   MySetting.shared.config(startSec: StartSection, baseVC: self, appid: APPID, color: CommonConfig.shared.mainColor, appname: nil)
}
```

显示时开始载入更多应用

```
    
override func viewDidAppear(_ animated: Bool) {
	tableView.reloadData()
	MySetting.shared.startLoadMoreApps {
	    DispatchQueue.main.async {
	        if self.tableView != nil {
	            self.tableView.reloadSections(IndexSet(integersIn: StartSection+1...StartSection+1), with: UITableViewRowAnimation.fade)
	        }
	    }
	}
}
```

Section数目：

```    
override func numberOfSections(in tableView: UITableView) -> Int {
     return StartSection + MySetting.shared.numberOfSettingSections()
}
    
```

行数： 

    
```
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 
    if section < StartSection {
        return ***
    }
    return MySetting.shared.numberOfRowsIn(section: section)
}
``` 

点击操作

```
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	if indexPath.section < StartSection {
        ...
    }
    else {
        if let cell = tableView.cellForRow(at: indexPath) {
            MySetting.shared.clickedAt(indexPath: indexPath, cell: cell)
        }
    }
}
```

Cell生成

```
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section < StartSection {        return cell
    }
    else {
        return MySetting.shared.cellFor(indexPath: indexPath)
    }
}
```

## Author

张忠, hellobanny@gmail.com




## License

ZZLib is available under the MIT license. See the LICENSE file for more info.
