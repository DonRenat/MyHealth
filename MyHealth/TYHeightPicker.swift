import UIKit

protocol TYHeightPickerDelegate {
    func selectedHeight(height: CGFloat, unit: HeightUnit)
}

enum HeightUnit: String {
    case CM = "CM"
    case Inch = "Inch"
}

class TYHeightPicker: UIView {
    
    var delegate: TYHeightPickerDelegate?
    
    private var pointerView: UIView!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 1, height: 75)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.init(named: "Aquamarine")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private var layout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    private var cellWidthIncludingSpacing: CGFloat {
        return layout.itemSize.width + layout.minimumLineSpacing
    }
    
    private let cellId = "cellId"
    
    private var selectedCM: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pointerView = createView(UIColor.init(named: "Sonic Silver")!)
        pointerView.translatesAutoresizingMaskIntoConstraints = false
        pointerView.transform = CGAffineTransform(rotationAngle: .pi/4)
        
        addSubview(collectionView)
        addSubview(pointerView)
        
        collectionView.register(TYLineCell.self, forCellWithReuseIdentifier: cellId)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapped)))
    }
    
    func setDefaultHeight(_ height: CGFloat, unit: HeightUnit) {
        self.layoutSubviews()
        collectionView.reloadData()
        collectionView.layoutSubviews()
        
        selectedCM = height
        delegate?.selectedHeight(height: selectedCM, unit: .CM)
        let offset = CGPoint(x: selectedCM * cellWidthIncludingSpacing - collectionView.contentInset.left, y: -collectionView.contentInset.top)
        collectionView.setContentOffset(offset, animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = true
        
        collectionView.frame = CGRect(x: 20, y: 60, width: 374, height: 75)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 374 / 2, bottom: 0, right: 374 / 2)
        
        pointerView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0.5).isActive = true
        pointerView.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        pointerView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        pointerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    private func createView(_ bgColor: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = bgColor
        return view
    }
    
    @objc private func handleTapped () { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension TYHeightPicker: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 201
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            as! TYLineCell
        let heightUnit: HeightUnit = .CM
        cell.calcLineViewHeight(indexPath.row, heightUnit: heightUnit)
        return cell
    }
}

extension TYHeightPicker: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        selectedCM = roundedIndex <= 0 ? 0 : roundedIndex
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let unit = HeightUnit.CM
        let height = selectedCM
        delegate?.selectedHeight(height: height, unit: unit)
    }
    
}

class TYLineCell: UICollectionViewCell {
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(named: "Sonic Silver")!
        return view
    }()
    
    var numberLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.textColor = UIColor.init(named: "Sonic Silver")!
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        addSubview(lineView)
        addSubview(numberLabel)
    }
    
    func calcLineViewHeight(_ index: Int, heightUnit: HeightUnit) {
        var firstModulo: Int = 0
        var secondModulo: Int = 0
        firstModulo = 10
        secondModulo = 5
        if index % firstModulo == 0 {
            lineView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 37)
            numberLabel.frame = CGRect(x: 0, y: 37 + 5, width: 50, height: 30)
            numberLabel.center.x = lineView.center.x
            let num = firstModulo == 12 ? index/12 : index
            numberLabel.text = "\(num)"
            
        } else if index % secondModulo == 0 {
            lineView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 28)
            numberLabel.frame = .zero
            numberLabel.text = ""
            
        } else {
            lineView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 18)
            numberLabel.frame = .zero
            numberLabel.text = ""
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

