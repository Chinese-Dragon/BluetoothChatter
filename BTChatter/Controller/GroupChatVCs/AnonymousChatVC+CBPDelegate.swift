//
//  AnonymousChatVC+CBPDelegate.swift
//  BTChatter
//
//  Created by Mark on 1/21/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import CoreBluetooth

extension AnonymousChatViewController: CBPeripheralDelegate {
	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		// there is only one services in our case
		if let service = peripheral.services?.last {
			peripheral.discoverCharacteristics([BleConstants.RX_MSG_UUID], for: service)
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		// there are one characteristics in our case
		userData.restore()
		if let characteristic = service.characteristics?.last,
			let data = (userData.name + "º" + lastMessage.text).data(using: .utf8) {
			// write the msg to the characteristic so that the receiver peripheral(iphone) will get the msg through didReceiveWrite CBPeripheralManagerDelegate method
			// send message as central (write to the characteristic of the peripheral so that it can recerive callback to display incoming message)
			peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
			
			// after write the value, we are done with this periphearl, disconnect
			centralManager.cancelPeripheralConnection(peripheral)
		}
	}
}
