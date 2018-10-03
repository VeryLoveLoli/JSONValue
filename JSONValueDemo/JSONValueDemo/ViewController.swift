//
//  ViewController.swift
//  JSONValueDemo
//
//  Created by 韦烽传 on 2018/10/2.
//  Copyright © 2018年 韦烽传. All rights reserved.
//

import UIKit
import JSONValue

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let jsonData = ["key": "value"]
        /*
         /// 或者
         let jsonData = ["key", "value"]
         /// 或者
         let jsonData = "{\"key\":\"value\"}"
         /// 或者
         let jsonData = "{\"key\":
         \"value\"}".data(using: .utf8)!
         
         jsonData: Dictionary<String,Any>,Array<Any>,String,Number,Int,UInt,Double,Float,Bool
         */
        
        var json = JSONValue(jsonData)
        
        /*
        /// Array
        let item = json[0].string
        
        /// Dictionary
        let item = json["key"].string
        
        /// path
        let item = json["key1"]["key2"].string
        let item = json["key"][0].string
        let item = json[["key", 0]].string
        */
        
        /*
        /// dynamicMemberLookup
        /// Array
        let item = json.0.string

        /// Dictionary
        let item = json.key.string

        /// path
        let item = json.key1.key2.string
        /// or
        let item = json.key.0.string
        /// if Dictionary key is int; jsonData = ["key": ["1": "value"]]
        let item = json.key["1"].string
        */
        
        /*
         /// JSON Value
         let dictionary = json.dictionary
         let array = json.array
         let string = json.string
         let number = json.number
         let bool = json.number.bool
         let int = json.number.int
         let double = json.number.double
         let float = json.number.float
         */
        
        /*
         /// Setter
         
         /// Dictionary
         json["key"] = JSONValue("value")
         json["key"].string = "value"
         json["key"].number = 10.0
         json["key"].number = true
         /// Array
         json[0] = JSONValue("value")
         json[0].string = "value"
         json[0].number = 10
         /// path
         json["key"][0].string = "value"
         json[["key", 0]].string = "value"
         */
        
        /*
        /// dynamicMemberLookup
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
        */
    }


}

