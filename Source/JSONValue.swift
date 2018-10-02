//
//  JSONValue.swift
//  JSONValueDemo
//
//  Created by 韦烽传 on 2017/5/25.
//  Copyright © 2017年 韦烽传. All rights reserved.
//

import Foundation

// MARK: - 数值

public struct Number {
    
    var value: String
    
    public init()              {  value = ""     }
    public init(_ v: Int)      {  value = "\(v)" }
    public init(_ v: Int8)     {  value = "\(v)" }
    public init(_ v: Int16)    {  value = "\(v)" }
    public init(_ v: Int32)    {  value = "\(v)" }
    public init(_ v: Int64)    {  value = "\(v)" }
    
    public init(_ v: UInt)     {  value = "\(v)" }
    public init(_ v: UInt8)    {  value = "\(v)" }
    public init(_ v: UInt16)   {  value = "\(v)" }
    public init(_ v: UInt32)   {  value = "\(v)" }
    public init(_ v: UInt64)   {  value = "\(v)" }

    public init(_ v: Float)    {  value = "\(v)" }
    public init(_ v: Double)   {  value = "\(v)" }
    public init(_ v: Bool)     {  value = v ? "1" : "0" }
    public init(_ v: String)   {  value = v }

    public var int:    Int     { get { return value.int } }
    public var int8:   Int8    { get { return value.int8 } }
    public var int16:  Int16   { get { return value.int16 } }
    public var int32:  Int32   { get { return value.int32 } }
    public var int64:  Int64   { get { return value.int64 } }

    public var uint:   UInt    { get { return value.uint } }
    public var uint8:  UInt8   { get { return value.uint8 } }
    public var uint16: UInt16  { get { return value.uint16 } }
    public var uint32: UInt32  { get { return value.uint32 } }
    public var uint64: UInt64  { get { return value.uint64 } }
    
    public var float:  Float   { get { return value.float } }
    public var double: Double  { get { return value.double } }
    public var bool:   Bool    { get { return value.bool } }
    public var string: String  { get { return  value } }
}

// MARK: - Number 等号 赋值

extension Number: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, ExpressibleByBooleanLiteral, ExpressibleByStringLiteral {
    
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
    
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

// MARK: - String -> 数值

extension String {
    
    public var int:    Int     { get {  return Int(self.double) } }
    public var int8:   Int8    { get { return Int8( (self.int << 56) >> 56 ) } }
    public var int16:  Int16   { get { return Int16( (self.int << 48) >> 48 ) } }
    public var int32:  Int32   { get { return Int32( (self.int << 32) >> 32 ) } }
    public var int64:  Int64   { get { return Int64( self.int ) } }
    
    public var uint:   UInt    { get { return self.double <= -1 ? (UInt.max - UInt(-self.int) + 1) : (self.double < 0 ? 0 : UInt(self.double)) } }
    public var uint8:  UInt8   { get { return UInt8( self.uint % ( UInt(UInt8.max) + 1 ) ) } }
    public var uint16: UInt16  { get { return UInt16( self.uint % ( UInt(UInt16.max) + 1 ) ) } }
    public var uint32: UInt32  { get { return UInt32( self.uint % ( UInt(UInt32.max) + 1 ) ) } }
    public var uint64: UInt64  { get { return UInt64( self.uint ) } }
    
    public var float:  Float   { get { return Float.init(self) ?? 0 } }
    public var double: Double  { get { return Double.init(self) ?? 0 } }
    public var bool:   Bool    { get { return self != "" && self != "0" && self != "false" } }
}

// MARK: - 空值

public struct Empty {
    
    // MARK: Parameter

    public var array: Array<Any> = []
    public var dictionary: Dictionary<String, Any> = [:]
    public var string: String = ""
    public var number: Number = Number()
    
    // MARK: init

    public init() {}
}

// MARK: - JSON数据取值

/**
 *  JSONValue
 *  简易快捷JSON数据取值
 */
@dynamicMemberLookup
public struct JSONValue {
    
    // MARK: init
    
    public init(_ obj: Any? = Empty()) {
        
        if let value = obj {
            
            switch value {
                
            case let json as JSONValue:
                
                object = json.object
                
            case let string as String:
                
                if let data = string.data(using: .utf8) {
                    
                    do {
                        
                        let json: Any = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        
                        switch json {
                        case let array as Array<Any>:
                            object = array
                        case let dictionary as Dictionary<String, Any>:
                            object = dictionary
                        default:
                            object = string
                        }
                        
                    } catch  {
                        
                        object = string
                    }
                }
                else {
                    
                    object = string
                }
                
            case let data as Data:
                
                do {
                    
                    let json: Any = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    object = json
                    
                } catch  {
                    
                    if let string = String.init(data: data, encoding: .utf8) {
                        
                        object = string
                    }
                    else {
                        
                        object = Empty()
                    }
                }
                
            case let number as Number:
                
                object = number
                
            case let int as IntegerLiteralType:
                
                object = Number(int)

            case let bool as BooleanLiteralType:
                
                object = Number(bool)

            case let float as FloatLiteralType:
                
                object = Number(float)
                
            case let array as Array<Any>:
                
                object = array
                
            case let dictionary as Dictionary<String, Any>:
                
                object = dictionary
                
            default:
                object = Empty()
            }
        }
        else {
            
            object = Empty()
        }
    }
    
    // MARK: Parameter
    
    /// 数据对象
    private var object: Any
    
    /// 字符串
    public var string: String {
        
        get {
            
            return self.JSONFormatString()
        }
        set {
            
            object = newValue
        }
    }
    
    /// 数值
    public var number: Number {
        
        get {
            
            switch object {
                
            case let number as Number:
                return number
            case let string as String:
                return Number.init(string)
            default:
                return Number()
            }
        }
        set {
            
            object = newValue
        }
    }
    
    /// 字典
    public var dictionary: Dictionary<String, JSONValue> {
        
        get {
            
            switch self.object {
                
            case let dictionary as Dictionary<String, JSONValue>:
                return dictionary
            case let dictionary as Dictionary<String, Any>:
                var dict = [String : JSONValue](minimumCapacity: dictionary.count)
                for (key, value) in dictionary {
                    dict[key] = JSONValue(value)
                }
                return dict
            default:
                return [:]
            }
        }
        set {
            
            object = newValue
        }
    }
    
    /// 数组
    public var array: Array<JSONValue> {
        
        get {
            
            switch object {
                
            case let array as Array<JSONValue>:
                return array
            case let array as Array<Any>:
                return array.map{ JSONValue($0) }
            default:
                return []
            }
        }
        set {
            
            object = newValue
        }
    }
    
    /**
     JSON格式化字符串
     
     - parameter    isValueObject:  是否是 数组/字典 元素值
     */
    public func JSONFormatString(_ isValueObject: Bool = false) -> String {
        
        switch object {
            
        case let string as String:
            if isValueObject {
                var value = string.replacingOccurrences(of: "\\", with: "\\\\")
                value = value.replacingOccurrences(of: "\"", with: "\\\"")
                value = value.replacingOccurrences(of: "\n", with: "\\n")
                value = value.replacingOccurrences(of: "\r", with: "\\r")
                value = value.replacingOccurrences(of: "\t", with: "\\t")
                return "\"\(value)\""
            }
            else {
                return string
            }
        case let number as Number:
            return number.string
        case let array as Array<Any>:
            var string = "["
            
            for item in array {
                
                string += JSONValue.init(item).JSONFormatString(true)
                string += ","
            }
            
            if array.count > 0 {
                
                string.remove(at: string.index(before: string.endIndex))
            }
            
            string += "]"
            return string
        case let dictionary as Dictionary<String, Any>:
            var string = "{"
            
            for item in dictionary {
                
                string += "\""
                string += item.key
                string += "\""
                string += ":"
                string += JSONValue.init(item.value).JSONFormatString(true)
                string += ","
            }
            
            if dictionary.count > 0 {
                
                string.remove(at: string.index(before: string.endIndex))
            }
            
            string += "}"
            return string
        default:
            return isValueObject ? "\"\"" : ""
        }
    }
    
    // MARK: Subscript
    
    /**
     数组下标
     */
    public subscript(_ index: Int) -> JSONValue {
        
        get {
            
            switch object {
                
            case let array as Array<Any>:
                
                if array.count > index {
                    
                    return JSONValue(array[index])
                }
                else {
                    
                    return JSONValue()
                }
                
            default:
                return JSONValue()
            }
        }
        set {
            
            switch object {
                
            case var array as Array<Any>:
                
                if array.count > index {
                    
                    array[index] = newValue.object
                }
                else {
                    
                    array.append(newValue.object)
                }
                object = array
                
            case let empty as Empty:
                
                object = empty.array
                self[index] = newValue
                
            default:
                print("JSONValue not an array or empty")
            }
        }
    }
    
    /**
     字典下标
     */
    public subscript(index: String) -> JSONValue {
        
        get {
            
            switch object {
                
            case let dictionary as Dictionary<String, Any>:
                return JSONValue(dictionary[index])
                
            default:
                return JSONValue()
            }
        }
        
        set {
            
            switch object {
                
            case var dictionary as Dictionary<String, Any>:
                
                dictionary[index] = newValue.object
                object = dictionary
                
            case let empty as Empty:
                
                object = empty.dictionary
                self[index] = newValue
                
            default:
                print("JSONValue not an dictionary or empty")
            }
        }
    }
    
    /**
     下标组
     */
    public subscript(indexes: [Any]) -> JSONValue {
        
        get {
            
            switch indexes.count {
                
            case 0:
                return self
            case 1:
                switch indexes[0] {
                    
                case let string as String:
                    return self[string]
                case let int as Int:
                    return self[int]
                default:
                    return JSONValue()
                }
            default:
                var items = indexes
                items.remove(at: 0)
                var nextJSON = self[[indexes[0]]]
                return nextJSON[items]
            }
        }
        set {
            
            switch indexes.count {
                
            case 0:
                return
            case 1:
                switch indexes[0] {
                    
                case let string as String:
                    self[string] = newValue
                case let int as Int:
                    self[int] = newValue
                default:
                    return
                }
            default:
                var items = indexes
                items.remove(at: 0)
                var nextJSON = self[[indexes[0]]]
                nextJSON[items] = newValue
                self[[indexes[0]]] = nextJSON
            }
        }
    }
    
    /**
     动态下标
     */
    public subscript(dynamicMember index: String) -> JSONValue {
        
        if let i = Int(index) {
            
            return self[i]
        }
        else {
            
            return self[index]
        }
    }
    
    /**
     是否是空值
     */
    public func isEmpty() -> Bool {
        
        switch object {
        case _ as Empty:
            return true
        default:
            return false
        }
    }
    
    /**
     格式输出
     */
    public func formatPrint() {
        
        let string = self.JSONFormatString()
        
        if let data = string.data(using: .utf8) {
            
            do {
                
                let json: Any = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                do {
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    
                    if let jsonString = String.init(data: jsonData, encoding: .utf8) {
                        
                        print(jsonString)
                    }
                    else {
                        
                        print(jsonData)
                    }
                    
                }
                catch {
                    
                    print(json)
                }
                
            } catch  {
                
                print(string)
            }
        }
        else {
            
            print(string)
        }
    }
}
