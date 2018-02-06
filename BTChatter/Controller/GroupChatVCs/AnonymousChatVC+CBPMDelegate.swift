//
//  AnonymousChatVC+CBPMDelegate.swift
//  BTChatter
//
//  Created by Mark on 1/21/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import CoreBluetooth
import JSQMessagesViewController

// MARK: - CBPeripheralManagerDelegate Methods
extension AnonymousChatViewController: CBPeripheralManagerDelegate {
	func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
		if peripheral.state == .poweredOn {
			// initialize service
			initService()
			
			// start advertiseing
			startAdvertising()
		} else {
			showAlert(with: "Make sure to turn on Bluetooth on the device")
		}
	}
	
	func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
		for request in requests {
			// AKA. Receiving incoming message as Peripheral (read write-request value that is writen by another device)
			if let value = request.value,
				let messageText = String(data: value, encoding: .utf8),
				let text = messageText.split(separator: "º").last,
				let senderName = messageText.split(separator: "º").first {
			
				if let msg = JSQMessage(senderId: "", displayName: String(senderName), text: String(text)) {
					messages.append(msg)
					
					finishReceivingMessage(animated: true)
				}
			}
			self.peripheralManager.respond(to: request, withResult: .success)
		}
	}
}
