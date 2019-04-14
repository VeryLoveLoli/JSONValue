# JSONValue

一个`Swift`语言简易的`JSON`取值

1. [Integration](#Integration)
2. [Usage](#Usage)
   - [Initialization](#Initialization)
   - [Subscript](#Subscript)
   - [JSON Value](#JSON Value)
   - [Setter](#Setter)

## Integration

### CocoaPods

```swift
source 'https://github.com/VeryLoveLoli/CocoaPodsSource.git'
platform :ios, '10.0'
use_frameworks!

target 'MyApp' do

    pod 'JSONValue', '0.0.5'
end

```
	
##### 更新CocoaPods
	pod repo add CocoaPodsSource https://github.com/VeryLoveLoli/CocoaPodsSource.git
	pod repo update
	pod install
	pod update

## Usage

### Initialization

```swift
import JSONValue
```

```swift
let jsonData = ["key": "value"]
/*
/// or
let jsonData = ["key", "value"]
/// or
let jsonData = "{\"key\":\"value\"}"
/// or
let jsonData = "{\"key\":
\"value\"}".data(using: .utf8)!

jsonData格式
Dictionary<String,Any>,Array<Any>,String,Number,Int,UInt,Double,Float,Bool,nil
*/

let json = JSONValue(jsonData)
```

### Subscript

```swift
/// Array
let item = json[0].string
```

```swift
/// Dictionary
let item = json["key"].string
```

```swift
/// path
let item = json["key1"]["key2"].string
/// or
let item = json["key"][0].string
/// or
let item = json[["key", 0]].string
```

##### v0.0.2 dynamicMemberLookup 支持动态下标取值

```swift
/// Array
let item = json.0.string
```

```swift
/// Dictionary
let item = json.key.string
```

```swift
/// path
let item = json.key1.key2.string
/// or
let item = json.key.0.string
/// if Dictionary key is int; jsonData = ["key": ["1": "value"]]
let item = json.key["1"].string
```

### JSON Value

```swift
let dictionary = json.dictionary
let array = json.array
let string = json.string
let number = json.number
let bool = json.number.bool
let int = json.number.int
let double = json.number.double
let float = json.number.float
```

### Setter

```swift
/// Dictionary
json["key"] = JSONValue("value")
json["key"].string = "value"
json["key"].number = 10.0
json["key"].number = true
```
```swift
/// Array
json[0] = JSONValue("value")
json[0].string = "value"
json[0].number = 10
```
```swift
/// path
json["key"][0].string = "value"
json[["key", 0]].string = "value"
```

##### v0.0.3 dynamicMemberLookup 支持动态下标设置值

```swift
/// Dictionary
json.key = JSONValue("value")
json.key.string = "value"
json.key.number = 10.0
json.key.number = true
/// Array
json.0 = JSONValue("value")
json.0.string = "value"
json.0.number = 10
/// path
json.key.0.string = "value"
/// if Dictionary key is int; jsonData = ["key": ["1": "value"]]
json.key["1"].string = "value"
```

##### v0.0.5 权限

```swift
/// 下标/字符串 可修改值的类型 以下的值一定会改变
var json = JSONValue(["x":["xx", "a"],"d":["k":"v"]])
json.x.string = "["1":"a"]"
json.d = "["1","a"]" 

/// number/dictionary/array 设置值的时候不是对应的类型或空类型
///则设置的值不能成功
var json = JSONValue(["x":["xx", "a"],"d":["k":"v"]])
json.x.number = 1 ///设置失败，x值的类型是数组
json.d.number = 2 ///设置失败，d值的类型是字典
json.d1.number = 3 ///设置成功，d1值的类型是空类型
json.x.x = JSONValue("aa") ///设置失败，x值的类型是数组
json.x1.x = JSONValue("aa") ///设置成功，d1值的类型是空类型
json.x.0.number = 10 ///设置成功，x数组第一个值是number(数值)类型
```