//
//  AnonymousChatVC+CBCMDelegate.swift
//  BTChatter
//
//  Created by Mark on 1/21/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

// MARK: - CentralManagerDelegate Methods
extension AnonymousChatViewController: CBCentralManagerDelegate {
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		if central.state == .poweredOn {
			// start scanning
			startScanning()
		} else {
			showAlert(with: "Make sure to turn on Bluetooth on the device")
		}
	}
	
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		
		if !discoveredPeripheralUUIDs.contains(peripheral.identifier.uuidString),
			let advertisementPayload = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
			
			print("Found interested peripheral: \(peripheral.identifier.uuidString)")
			let payloadComponenets = advertisementPayload.components(separatedBy: "|")
			let name = payloadComponenets[0]
			let avatarId = Int(payloadComponenets[1])!
			let colorId = Int(payloadComponenets[2])!
			
			let newDevice = Device(peripheral: peripheral,
								   name: name,
								   avatarId: avatarId,
								   colorId: colorId)
			
			discoveredDevices.append(newDevice)
			discoveredPeripheralUUIDs.append(peripheral.identifier.uuidString)
		}
		
	}
	
	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		// connect to every peripheral we've discoverred so far and discover their services
		peripheral.delegate = self
		peripheral.discoverServices([BleConstants.SERVICE_UUID])
		print("Peripheral: \(peripheral.identifier.uuidString) connected")
	}
	
	func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		print("Peripheral: \(peripheral.identifier.uuidString) failed to connected, REASON: \(error?.localizedDescription ?? "")")
	}
	
	func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
		// this can be triggerd by peripheral (another device go to background which cancel all the connections so that we will remove the corresponding connection as well)
		print("Peripheral: \(peripheral.identifier.uuidString) disconnected")
	}
}
