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
    
    private var value: String
    
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

    public var int:    Int     { get { return value.int } set { value = "\(newValue)" } }
    public var int8:   Int8    { get { return value.int8 } set { value = "\(newValue)" } }
    public var int16:  Int16   { get { return value.int16 } set { value = "\(newValue)" } }
    public var int32:  Int32   { get { return value.int32 } set { value = "\(newValue)" } }
    public var int64:  Int64   { get { return value.int64 } set { value = "\(newValue)" } }

    public var uint:   UInt    { get { return value.uint } set { value = "\(newValue)" } }
    public var uint8:  UInt8   { get { return value.uint8 } set { value = "\(newValue)" } }
    public var uint16: UInt16  { get { return value.uint16 } set { value = "\(newValue)" } }
    public var uint32: UInt32  { get { return value.uint32 } set { value = "\(newValue)" } }
    public var uint64: UInt64  { get { return value.uint64 } set { value = "\(newValue)" } }
    
    public var float:  Float   { get { return value.float } set { value = "\(newValue)" } }
    public var double: Double  { get { return value.double } set { value = "\(newValue)" } }
    public var bool:   Bool    { get { return value.bool } set { value = "\(newValue)" } }
    public var string: String  { get { return  value } set { value = newValue } }
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

// MARK: - 类型

public enum JSONType {
    
    /// 数组
    case array
    /// 字典
    case dictionary
    /// 数组
    case number
    /// 空
    case empty
}

// MARK: - JSON数据取值

/**
 *  JSONValue
 *  简易快捷JSON数据取值
 */
@dynamicMemberLookup
public struct JSONValue {
    
    // MARK: init
    
    public init(_ obj: Any? = nil) {
        
        if let value = obj {
            
            switch value {
                
            case let json as JSONValue:
                
                type = json.type
                dictionary = json.dictionary
                array = json.array
                number = json.number
                
            case let string as String:
                
                if let data = string.data(using: .utf8) {
                    
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        
                        switch json {
                        case let a as Array<Any>:
                            type = .array
                            array = a.map{ JSONValue($0) }
                        case let d as Dictionary<String, Any>:
                            type = .dictionary
                            for (k,v) in d {
                                dictionary[k] = JSONValue(v)
                            }
                        default:
                            type = .number
                            number = Number(string)
                        }
                        
                    } catch  {
                        
                        type = .number
                        number = Number(string)
                    }
                }
                else {
                    
                    type = .number
                    number = Number(string)
                }
                
            case let data as Data:
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    switch json {
                    case let a as Array<Any>:
                        type = .array
                        array = a.map{ JSONValue($0) }
                    case let d as Dictionary<String, Any>:
                        type = .dictionary
                        for (k,v) in d {
                            dictionary[k] = JSONValue(v)
                        }
                    default:
                        if let string = String.init(data: data, encoding: .utf8) {
                            
                            type = .number
                            number = Number(string)
                        }
                    }
                    
                } catch  {
                    
                    if let string = String.init(data: data, encoding: .utf8) {
                        
                        type = .number
                        number = Number(string)
                    }
                }
                
            case let n as Number:
                
                type = .number
                number = n
                
            case let int as IntegerLiteralType:
                
                type = .number
                number = Number(int)

            case let bool as BooleanLiteralType:
                
                type = .number
                number = Number(bool)

            case let float as FloatLiteralType:
                
                type = .number
                number = Number(float)
                
            case let a as Array<Any>:
                
                type = .array
                array = a.map{ JSONValue($0) }
                
            case let d as Dictionary<String, Any?>:
                
                type = .dictionary
                for (k,v) in d {
                    dictionary[k] = JSONValue(v)
                }
                
            case _ as NSNull:
                
                type = .empty
                
            default:
                
                print("JSONValue value not an dictionary or array or number or empty")
            }
        }
    }
    
    // MARK: Parameter
    
    /// 类型
    private var type: JSONType = .empty
    
    /// 字典
    public var dictionary = Dictionary<String, JSONValue>()
    
    /// 数组
    public var array = Array<JSONValue>()
    
    /// 数值
    private var value = Number()
    
    /// 数值
    public var number: Number {
        
        get {
            
            return value
        }
        
        set {
            
            switch type {
            case .number:
                value = newValue
            case .empty:
                type = .number
                value = newValue
            default:
                print("JSONValue not an number or empty")
            }
        }
    }
    
    /// 字符串
    public var string: String {
        
        get {
            
            switch type {
            case .array, .dictionary:
                return JSONFormatString()
            case .number, .empty:
                return number.string
            }
        }
        set {
            
            let json = JSONValue(newValue)
            
            type = json.type
            dictionary = json.dictionary
            array = json.array
            number = json.number
        }
    }
    
    
    
    /**
     JSON格式化字符串
     
     - parameter    isValueObject:      是否是 数组/字典 元素值
     - parameter    isPrettyPrinted:    是否漂亮的格式
     - parameter    level:              层次字符串
     */
    public func JSONFormatString(_ isValueObject: Bool = false, isPrettyPrinted: Bool = false, level: String = "") -> String {
        
        switch type {
            
        case .number:
            if isValueObject {
                var value = number.string.replacingOccurrences(of: "\\", with: "\\\\")
                value = value.replacingOccurrences(of: "\"", with: "\\\"")
                value = value.replacingOccurrences(of: "\n", with: "\\n")
                value = value.replacingOccurrences(of: "\r", with: "\\r")
                value = value.replacingOccurrences(of: "\t", with: "\\t")
                return "\"\(value)\""
            }
            else {
                return number.string
            }
        case .array:
            var arrayString = "["
            for item in array {
                if isPrettyPrinted {
                    arrayString += "\n\t" + level
                }
                arrayString += item.JSONFormatString(true, isPrettyPrinted: isPrettyPrinted, level: isPrettyPrinted ? level + "\t" : level)
                arrayString += ","
            }
            if array.count > 0 {
                arrayString.remove(at: arrayString.index(before: arrayString.endIndex))
            }
            if isPrettyPrinted {
                arrayString += "\n" + level
            }
            arrayString += "]"
            return arrayString
        case .dictionary:
            var dictionaryString = "{"
            for (key,value) in dictionary {
                if isPrettyPrinted {
                    dictionaryString += "\n\t" + level
                }
                dictionaryString += "\""
                dictionaryString += key
                dictionaryString += "\""
                dictionaryString += ":"
                if isPrettyPrinted {
                    dictionaryString += " "
                }
                dictionaryString += value.JSONFormatString(true, isPrettyPrinted: isPrettyPrinted, level: isPrettyPrinted ? level + "\t" : level)
                dictionaryString += ","
            }
            if dictionary.count > 0 {
                
                dictionaryString.remove(at: dictionaryString.index(before: dictionaryString.endIndex))
            }
            if isPrettyPrinted {
                dictionaryString += "\n" + level
            }
            dictionaryString += "}"
            return dictionaryString
        case .empty:
            return isValueObject ? "null" : ""
        }
    }
    
    // MARK: Subscript
    
    /**
     数组下标
     */
    public subscript(_ index: Int) -> JSONValue {
        
        get {
            
            if type == .array && array.count>index {
                return array[index]
            }
            return JSONValue()
        }
        set {
            
            switch type {
            case .array:
                if array.count > index {
                    array[index] = newValue
                }
                else {
                    array.append(newValue)
                }
            case .empty:
                type = .array
                array.append(newValue)
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
            
            if type == .dictionary, let value = dictionary[index] {
                return value
            }
            return JSONValue()
        }
        
        set {
            
            switch type {
            case .dictionary:
                dictionary[index] = newValue
            case .empty:
                type = .dictionary
                dictionary[index] = newValue
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
        
        get {
            
            if let i = Int(index), type == .array || type == .empty {
                
                return self[i]
            }
            else {
                
                return self[index]
            }
        }
        set {
            
            if let i = Int(index), type == .array || type == .empty {
                
                self[i] = newValue
            }
            else {
                
                self[index] = newValue
            }
        }
    }
    
    /**
     是否是空值
     */
    public func isEmpty() -> Bool {
        
        switch type {
        case .empty:
            return true
        default:
            return false
        }
    }
    
    /**
     格式输出
     */
    public func formatPrint() {
        
        print(JSONFormatString(isPrettyPrinted: true))
    }
}
