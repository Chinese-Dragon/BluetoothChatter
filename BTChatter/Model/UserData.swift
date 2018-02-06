//
//  UserData.swift
//  BTChatter
//
//  Created by Mark on 1/22/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation

class UserData: NSObject {
	static let shareInstance = UserData()
	private let userDataKey = "userData"
	
	var name: String = ""
	var avatarId: Int = 0
	var colorId: Int = 0
	var deviceId: String = ""
	
	var hasAllDataFilled: Bool {
		return !name.isEmpty && avatarId > 0 && !deviceId.isEmpty
	}
	
	private override init(){}
	
	func save() {
		var dictionary = [String: Any]()
		dictionary["name"] = name
		dictionary["avatarId"] = avatarId
		dictionary["colorId"] = colorId
		dictionary["deviceId"] = deviceId
		
		UserDefaults.standard.set(dictionary, forKey: userDataKey)
	}
	
	func restore() {
		if let dictionary = UserDefaults.standard.dictionary(forKey: userDataKey) {
			name = dictionary["name"] as? String ?? ""
			avatarId = dictionary["avatarId"] as? Int ?? 0
			colorId = dictionary["colorId"] as? Int ?? 0
			deviceId = dictionary["deviceId"] as? String ?? ""
		}
	}
	
}
