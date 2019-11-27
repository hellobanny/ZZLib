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

定义开始的Section

```
let StartSection = 1
```

初始化

```
override func viewDidLoad() {
   super.viewDidLoad()
   ZZSetting.shared.config(startSec: 0, baseVC: self, appid: APPID, color: CommonConfig.shared.mainColor, appname: "My Goals".localized(), moreApps: [.redbox,.measure,.memory])
}
```


Section数目：

```    
override func numberOfSections(in tableView: UITableView) -> Int {
     return StartSection + ZZSetting.shared.numberOfSettingSections()
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
            ZZSetting.shared.clickedAt(indexPath: indexPath, cell: cell)
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
        return ZZSetting.shared.cellFor(indexPath: indexPath)
    }
}
```

Section的标题

```
override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return ZZSetting.shared.titleFor(section:section)
}
```

## Author

张忠, hellobanny@gmail.com




## License

ZZLib is available under the MIT license. See the LICENSE file for more info.
