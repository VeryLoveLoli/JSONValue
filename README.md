# JSONValue

`Swift` easy value `JSON`, Support all systems: `macOS` `iOS` `watchOS` `tvOS` `linux ` ... As long as you can run `Swift`

一个`Swift`语言简易的`JSON`取值，支持 `macOS` `iOS` `watchOS` `tvOS` `linux ` ... 所有系统，只要能运行 `Swift`


1. [Integration](#Integration)
2. [Usage](#Usage)
   - [Initialization](#Initialization)
   - [Subscript](#Subscript)
   - [JSON Value](#JSON Value)
   - [Setter](#Setter)

## Integration

### Xcode
    File -> Swift Packages -> Add Package dependency

### CocoaPods

[GitHub JSONValue](https://github.com/VeryLoveLoli/JSONValue)

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
/// or
let json = jsonData.json
```

### Subscript dynamicMemberLookup 支持动态下标取值/赋值

```swift
/// Array
let item = json[0]
let number = json[0].number
let string = json[0].number.string
let bool = json[0].number.bool

let item = json.0
let number = json.0.number
let string = json.0.number.string
let bool = json.0.number.bool

json[0] = "string".json
json[0] = 123.json
```

```swift
/// Dictionary
let item = json["key"]
let number = json["key"].number
let string = json["key"].number.string
let bool = json["key"].number.bool

let item = json.key
let number = json.key.number
let string = json.key.number.string
let bool = json.key.number.bool

json.key = "string".json
json.key = 123.json
```

```swift
/// path
let item = json["key1"]["key2"]
/// or
let item = json["key"][0]
/// or
let item = json[["key", 0]]

json["key1"]["key2"] = "string".json
json["key"][0] = "string".json
json[["key", 0]] = "string".json 

let item = json.key1.key2
let item = json.key.0

json.key1.key2 = "string".json
json.key.0 = true.json
```

### JSON Value

```swift
let dictionary = json.dictionary
let array = json.array
let number = json.number
let string = json.number.string
let bool = json.number.bool
let int = json.number.int
let double = json.number.double
let float = json.number.float
```
