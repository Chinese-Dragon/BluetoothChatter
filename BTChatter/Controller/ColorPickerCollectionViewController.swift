import UIKit

class ColorPickerViewController: UICollectionViewController
{
	let reuseIdentifier = "ColorPickerCell"
	let columnCount = 3
	let margin : CGFloat = 10
	
	// MARK: View lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// TODO: check out collectionview controller !!
		setCollectionViewLayout(collectionView: collectionView, margin: margin)
	}
}

// MARK: - UICollectionViewDataSource protocol
extension ColorPickerViewController {
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return BleConstants.colors.count
	}
	
	// make a cell for each cell index path
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath)
		
		cell.backgroundColor = BleConstants.colors[indexPath.item]
		
		return cell
	}
}

// MARK: - UICollectionViewDelegate protocol
extension ColorPickerViewController {
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let userData =  UserData.shareInstance
		userData.colorId = indexPath.item
		userData.save()
		
		dismiss(animated: true, completion: nil)
	}
}

extension ColorPickerViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
		let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(columnCount)).rounded(.down)
		return CGSize(width: itemWidth, height: itemWidth)
	}
}

