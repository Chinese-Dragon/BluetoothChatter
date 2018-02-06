//
//  Device.swift
//  BTChatter
//
//  Created by Mark on 1/22/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Device {
	var peripheral : CBPeripheral
	var name : String
	var avatarId: Int
	var colorId: Int
}
