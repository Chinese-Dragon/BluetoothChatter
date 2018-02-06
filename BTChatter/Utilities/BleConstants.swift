//
//  BleConstants.swift
//  BTChatter
//
//  Created by Mark on 1/19/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

struct BleConstants {
	static let kAvatarImagePrefix = "avatar"
	
	static let colors = [UIColor(red: 0/255, green: 102/255, blue:155/255, alpha: 1.0),
						 UIColor(red: 102/255, green: 204/255, blue:255/255, alpha: 1.0),
						 UIColor(red: 0/255, green: 153/255, blue:51/255, alpha: 1.0),
						 UIColor(red: 255/255, green: 153/255, blue:0/255, alpha: 1.0),
						 UIColor(red: 255/255, green: 51/255, blue:0/255, alpha: 1.0),
						 UIColor(red: 255/255, green: 51/255, blue:204/255, alpha: 1.0),
						 UIColor(red: 255/255, green: 255/255, blue:0/255, alpha: 1.0),
						 UIColor(red: 153/255, green: 51/255, blue:255/255, alpha: 1.0),
						 UIColor(red: 153/255, green: 102/255, blue:0/255, alpha: 1.0)]
	
	static let SERVICE_UUID = CBUUID(string: "4DF91029-B356-463E-9F48-BAB077BF3EF6")
	static let RX_MSG_UUID = CBUUID(string: "3B66D024-2336-4F22-A980-8095F4898C46")
	static let RX_PROPERTIES: CBCharacteristicProperties = .write
	static let RX_PERMISSIONS: CBAttributePermissions = .writeable
}
