//
//  ProfileViewController.swift
//  BTChatter
//
//  Created by Mark on 1/22/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit
import TWMessageBarManager

class ProfileViewController: UIViewController
{
	@IBOutlet weak var avatarButton: UIButton!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var pickColorButton: UIButton!
	@IBOutlet weak var nextButton: UIButton!
	
	// flag to check if we are in the update screen or register screen
	var isUpdateScreen : Bool = false
	
	private lazy var userData = UserData.shareInstance
	
	private lazy var tapRecognizer = {
		return UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
	}()
	
	// MARK: View lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		userData.restore()
		isUpdateScreen = userData.hasAllDataFilled
		setupUI()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		dismissKeyboard()
		view.removeGestureRecognizer(tapRecognizer)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		populateData()
		view.addGestureRecognizer(tapRecognizer)
	}
	
	@IBAction func nextButtonClick(_ sender: Any) {
		// Save user name on button clicked
		userData.restore()
		saveName()
		saveDeviceInfo()
		
		if (userData.avatarId == 0) {
			showAlert(with: "_alert_choose_avatar".localized)
		} else if (userData.name.isEmpty) {
			showAlert(with: "_alert_enter_name".localized)
		} else {
			if (isUpdateScreen) {
				// TODO: Show Success Message
				TWMessageBarManager().showMessage(withTitle: "Success", description: "Successfully update profile", type: .success)
			} else {
				// TODO: Change root back to Tabbar controller
				print("About to go to MAIN")
				swapRoot()
			}
		}
	}
}

// MARK: - Helper Methods
private extension ProfileViewController {
	func saveName() {
		let name : String = nameTextField.text ?? ""
		userData.name = name
		userData.save()
	}
	
	func saveDeviceInfo() {
		let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
		userData.deviceId = deviceUUID!
		userData.save()
	}
	
	func setupUI() {
		nextButton.layer.cornerRadius = 10
		nameTextField.delegate = self
		pickColorButton.setTitle("_register_pick_color".localized, for: .normal)
	}
	
	func populateData() {
		userData.restore()
		
		navigationItem.title = userData.hasAllDataFilled ? "_profile_title".localized : "_register_title".localized 
		
		let buttonTitle = userData.hasAllDataFilled ? "_save".localized : "_next".localized
		nextButton.setTitle(buttonTitle, for: .normal)
		
		avatarButton.setImage(generateAvatar(for: userData.avatarId), for: UIControlState.normal)
		view.backgroundColor = BleConstants.colors[userData.colorId]
		
		nameTextField.text = userData.name.isEmpty ? nameTextField.text : userData.name
	}
	
	@objc func dismissKeyboard() {
		nameTextField.resignFirstResponder()
	}
	
	func swapRoot() {
		guard let window = UIApplication.shared.keyWindow else {
			return
		}
		
		guard let rootViewController = window.rootViewController else {
			return
		}
		
		let authStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		let vc = authStoryboard.instantiateViewController(withIdentifier: "MainTabbarVC") as! UITabBarController
		
		vc.view.frame = rootViewController.view.frame
		vc.view.layoutIfNeeded()
		
		UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
			window.rootViewController = vc
		}, completion: { completed in
			rootViewController.dismiss(animated: true, completion: nil)
		})
	}
}

extension ProfileViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		dismissKeyboard()
		return true
	}
}

