//
//  AnonymousChatVC+BLEHelper.swift
//  BTChatter
//
//  Created by Mark on 1/21/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

// MARK: - BLE Helper methods
extension AnonymousChatViewController {
	func setup() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(wrapUp),
			name: NSNotification.Name.UIApplicationDidEnterBackground,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(startUp),
			name: NSNotification.Name.UIApplicationWillEnterForeground,
			object: nil)
		
		self.edgesForExtendedLayout = []
		
		userData.restore()
		senderId = userData.deviceId
		senderDisplayName = userData.name
	}
	
	@objc func startUp() {
		startAdvertising()
		startScanning()
	}
	
	@objc func wrapUp() {
		stopAdvertising()
		stopScanning()
		clearPeripherals()
	}
	
	// start advertising if not, vice versa
	func startAdvertising() {
		if !peripheralManager.isAdvertising {
			print("Advertising...")
			
			userData.restore()
			
			let advertisementData = String(format: "%@|%d|%d", userData.name, userData.avatarId, userData.colorId)
			peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [BleConstants.SERVICE_UUID] as [Any],
												CBAdvertisementDataLocalNameKey: advertisementData])
		}
	}
	
	func stopAdvertising() {
		if peripheralManager.isAdvertising {
			print("Advertising Stoppd")
			peripheralManager.stopAdvertising()
		}
	}
	
	// start scanning if not, vice versa
	func startScanning() {
		if !centralManager.isScanning {
			print("Scanning...")
			centralManager.scanForPeripherals(withServices: [BleConstants.SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
		}
	}
	
	func stopScanning() {
		if centralManager.isScanning {
			print("Scanning Stopped")
			centralManager.stopScan()
		}
	}
	
	@objc func clearPeripherals(){
		// clean up
		discoveredDevices.removeAll()
		discoveredPeripheralUUIDs.removeAll()
	}
	
	// Setting the read and write permissions for a characteristic’s value is different from specifying the read and write properties for a characteristic’s value. Specifying the read and write properties for a characteristic’s value lets the client (a central) know what read and write permissions of the characteristic’s value are set. Specifying the read and write permissions for a characteristic’s value actually sets the permissions for the server (the peripheral) to allow the type of read or write specified by the characteristic’s properties. Therefore, if you specify read or write properties when initializing a mutable characteristic, you must also specify corresponding read or write permissions for that characteristic.
	func initService() {
		let serialService = CBMutableService(type: BleConstants.SERVICE_UUID, primary: true)
		
		let rx_msg = CBMutableCharacteristic(type: BleConstants.RX_MSG_UUID, properties: BleConstants.RX_PROPERTIES, value: nil, permissions: BleConstants.RX_PERMISSIONS)
		
		serialService.characteristics = [rx_msg]
		
		peripheralManager.add(serialService)
	}
}
