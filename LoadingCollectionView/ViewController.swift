//
//  ViewController.swift
//  LoadingCollectionView
//
//  Created by 위대연 on 2021/02/17.
//

import UIKit

struct ImageItem {
    let webUrl:String
    let fileName:String
}

class ImageButton:UIButton {
    var setSelected = false {
        didSet{
            self.backgroundColor = setSelected ? UIColor.darkGray : UIColor.white
        }
    }
}

class ViewController: UIViewController {
    var collectionView:UICollectionView!
    var data:[ImageItem] = []
    let templetData = Array<ImageItem>(repeating: ImageItem(webUrl: "", fileName: ""), count: 30)
    var toolbarButtons:[ImageButton] = []
    var toolbar:UIView!
    var isLoaded = false {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    let token = ""
    let toolbarHeight = CGFloat(50)
    
    var selectedTag = 0 {
        didSet{
            for button in self.toolbarButtons {
                button.setSelected = false
            }
            self.isLoaded = false
            self.collectionView.reloadData()
            
            self.toolbarButtons[selectedTag].setSelected = true
            self.updatePageData(selecteTag: selectedTag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupToolbar()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let size = CGSize(width: self.view.frame.width, height: self.view.frame.height - self.toolbarHeight)
        let itemWidth = (self.view.frame.width - 20) / 4
        let itemHeight = itemWidth * 1.3
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        
        self.collectionView = UICollectionView(frame: CGRect(origin: .zero, size: size), collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuse_id)
        self.view.addSubview(collectionView)
        
        self.collectionView.backgroundColor = .white
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
    
    func setupToolbar() {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.toolbarHeight)
        toolbar = UIView(frame: rect)
        self.view.addSubview(toolbar)
        toolbar.backgroundColor = .gray
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: self.toolbarHeight)
        ])
    }
    
    func updatePageData(selecteTag:Int){
        let index = selectedTag
        guard index < self.data.count else {
            return
        }
        /// 네트워크 로 데이터 갱신
        
//        self.isLoaded = true
    }
    
    
}
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoaded {
            print(data.count)
            return data.count
        }
        print(templetData.count)
        return templetData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuse_id, for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .brown
        cell.image = nil
        
        let item = isLoaded ? data[indexPath.item] : templetData[indexPath.item]
        
        if let url = URL(string: item.webUrl) {
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                cell.image = image
            }
        }
        
        return cell
    }
}

class CollectionViewCell:UICollectionViewCell {
    static let reuse_id = "collectionview_cell"
    private var imageView:UIImageView!
    var image:UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView = UIImageView(frame: self.contentView.frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
