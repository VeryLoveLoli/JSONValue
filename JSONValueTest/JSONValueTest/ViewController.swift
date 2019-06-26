//
//  ViewController.swift
//  JSONValueTest
//
//  Created by 韦烽传 on 2018/10/3.
//  Copyright © 2018年 韦烽传. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let ss = ["[]", "[111]", "[111,222]", "[[111]]", "[[111,222]]", "[{}]", "[{\"123\": 123}]", "[{},{}]", "[{\"111\": 123, \"222\": 222}]", "[{\"111\": 123, \"222\": 222}, {\"111\": 123, \"222\": 222}]", "[null]", "[null, null]", "[{\"111\": null}]", "{}", "{\"\":\"\"}", "{\"1\":\"\",\"2\":2}", "{\"1\": [[{\"2\": 123}]]}", "xxs[]dedc", "", "[\"\"]"]
        
        for s in ss {
            
            print("\n\n")
            
            let array = [UInt8].init(s.utf8)
            let j = JSONValue.init(bytes: array)
            print(j.valueType)
            j.formatPrint()
            
            print("\n")
            print(s.json.valueType)
            s.json.formatPrint()
        }
        
        print("----")
        var json = JSONValue([])
        json.remove(-1)
        json.formatPrint()
        json[-1].formatPrint()
        json[-1] = "123".json
        json.formatPrint()
        json[-1] = "321".json
        json.formatPrint()
    }
}
