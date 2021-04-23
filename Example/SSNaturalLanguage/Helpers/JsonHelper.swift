//
//  JsonHelper.swift
//  NaturalLanguageDemo
//
//  Created by Abhi Makadiya on 21/03/21.
//

import UIKit

class JsonHelper: NSObject {
    
    class func getLanguageJson() -> [String: String] {
            do {
                if let file = Bundle.main.url(forResource: "Language", withExtension: "json") {
                    let data = try Data(contentsOf: file)
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let object = json as? [String: String] {
                        // json is a dictionary
                        return object
                    }  else {
                        return [String: String]()
                    }
                } else {
                    return [String: String]()
                }
            } catch {
                return [String: String]()
            }
        
        
        
        /*
        if let path = Bundle.main.path(forResource: "Language", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, String> {
                    return jsonResult
                } else {
                    return [String: String]()
                }
            } catch {
                return [String: String]()
            }
        } else {
            return [String: String]()
        }*/
    }
    
}
