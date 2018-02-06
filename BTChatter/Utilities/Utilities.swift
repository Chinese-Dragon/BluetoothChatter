//
//  Utilities.swift
//  BTChatter
//
//  Created by Mark on 1/21/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	func showAlert(with msg: String) {
		let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
		let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
}

extension UICollectionViewController {
	func setCollectionViewLayout(collectionView: UICollectionView?, margin: CGFloat) {
		guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
		flowLayout.minimumInteritemSpacing = margin
		flowLayout.minimumLineSpacing = margin
		flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
		flowLayout.estimatedItemSize = flowLayout.itemSize
	}
}

extension String {
	var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}
}

extension UIViewController {
	func generateAvatar(for avatarId: Int) -> UIImage {
		return UIImage(named: String(format: "%@%d", BleConstants.kAvatarImagePrefix, avatarId))!
	}
}
