//
//  ViewController.swift
//  BTChatter
//
//  Created by Mark on 1/19/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit
import CoreBluetooth
import JSQMessagesViewController

class AnonymousChatViewController: JSQMessagesViewController {
	@IBOutlet weak var tableview: UITableView!
	@IBOutlet weak var inputText: UITextField!
	
	// JSQ Message VC Setup
	var messages: [JSQMessage] = []
	
	var outgoingBubbleImageView: JSQMessagesBubbleImage {
		let bubbleImageFactory = JSQMessagesBubbleImageFactory()
		return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
	}
	
	var incomingBubbleImageView: JSQMessagesBubbleImage {
		let bubbleImageFactory = JSQMessagesBubbleImageFactory()
		return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
	}
	
	// BLE Related properties
	var centralManager: CBCentralManager!
	var peripheralManager: CBPeripheralManager!
	var currentPeripheral: CBPeripheral!
	var discoveredDevices: [Device] = [] {
		didSet {
			title = "Active users: \(discoveredDevices.count)"
		}
	}
	var discoveredPeripheralUUIDs: [String] = []
	var lastMessage: JSQMessage!
	var timer = Timer()
	
	lazy var userData = UserData.shareInstance
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
		// TODO: Try other dispatch queues other than main queue, might be a global? or background customized concurrent queue?
		centralManager = CBCentralManager(delegate: self, queue: nil)
		peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("ViewwillAppear is called")
//		startUp()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		print("ViewWillDisappear is called")
//		wrapUp()
	}
	
	deinit {
		print("Remove Observer")
		NotificationCenter.default.removeObserver(self)
	}
}

extension AnonymousChatViewController {
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
		return messages[indexPath.item]
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages.count
	}
	
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
		let message = messages[indexPath.item]
		return setupMsgBubble(with: message.senderDisplayName)
	}
	
	override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
		let message = messages[indexPath.item]
		return setupAvatar(with: message.senderDisplayName)
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
		let message = messages[indexPath.item]
		
		if message.senderDisplayName == senderDisplayName {
			cell.textView?.textColor = UIColor.white
		} else {
			cell.textView?.textColor = UIColor.black
		}
		return cell
	}
	
	override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
		
		addMessage(withId: senderId, name: senderDisplayName, text: text)
		
		JSQSystemSoundPlayer.jsq_playMessageSentSound()
		
		finishSendingMessage(animated: true)
		
		// setup connection with all discovered peripherals and send message to all of them
		for receiver in discoveredDevices {
			centralManager.connect(receiver.peripheral, options: nil)
		}
	}
	
	override func didPressAccessoryButton(_ sender: UIButton!) {
		return
	}
}

// Helper methods for JSQVC
extension AnonymousChatViewController {
	private func setupMsgBubble(with senderName: String) -> JSQMessagesBubbleImage {
		userData.restore()
		var colorId = 0
		if senderName == userData.name {
			colorId = userData.colorId
			return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: BleConstants.colors[colorId])
		} else {
			let senderDevice = discoveredDevices.filter { $0.name == senderName }.last!
			colorId = senderDevice.colorId
			return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: BleConstants.colors[colorId])
		}
	}
	
	private func setupAvatar(with senderName: String) -> JSQMessagesAvatarImage {
		userData.restore()
		var avatarId = 0
		if senderName == userData.name {
			avatarId = userData.avatarId
		} else {
			let senderDevice = discoveredDevices.filter { $0.name == senderName }.last!
			avatarId = senderDevice.avatarId
		}
		
		return JSQMessagesAvatarImageFactory.avatarImage(with: generateAvatar(for: avatarId), diameter: 40)
	}
	
	private func addMessage(withId id: String, name: String, text: String) {
		if let message = JSQMessage(senderId: id, displayName: name, text: text) {
			// keep tracking the last message send by the current user so that we can write it to characteristic
			lastMessage = message
			messages.append(message)
		}
	}
}
