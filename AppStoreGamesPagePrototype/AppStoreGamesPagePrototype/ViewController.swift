//
//  ViewController.swift
//  AppStoreGamesPagePrototype
//
//  Created by Amir Teacher on 18.05.2021.
//

import UIKit

func primitiveLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.5),
        heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

    let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .absolute(60)
    )
    let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: groupSize,
        subitem: item,
        count: 2
    )
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)
    return UICollectionViewCompositionalLayout(section: section)
}

let inset: CGFloat = 10
let spacing: CGFloat = 8
let screenWidth = UIScreen.main.bounds.size.width

func promotionsSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: spacing, bottom: 16, trailing: spacing)
    
    let groupSize = NSCollectionLayoutSize(
        widthDimension: .absolute(screenWidth - 2 * inset - 2 * spacing),
        heightDimension: .absolute(250)
    )
    let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: groupSize,
        subitems: [ item ]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPagingCentered
    return section
}

func popularSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1 / 3)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: spacing, bottom: 4, trailing: spacing)
    
    let groupSize = NSCollectionLayoutSize(
        widthDimension: .absolute(screenWidth - 2 * inset - 2 * spacing),
        heightDimension: .absolute(250)
    )
    let group = NSCollectionLayoutGroup.vertical(
        layoutSize: groupSize,
        subitem: item,
        count: 3
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPagingCentered
    return section
}

func suggestionsSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
    
    let groupSize = NSCollectionLayoutSize(
        widthDimension: .absolute((screenWidth - 2 * inset - 2 * spacing) * 0.5),
        heightDimension: .absolute(130)
    )
    let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: groupSize,
        subitems: [ item ]
    )
    group.contentInsets = .init(top: 0, leading: spacing + inset, bottom: 0, trailing: 0)
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    return section
}

enum Section: Int, CaseIterable {
    case promotions
    case popular
    case suggestions
}

// Section.allCases == [ .promotions, .popular ]

func appStoreLayout() -> UICollectionViewCompositionalLayout {
    
    let layout = UICollectionViewCompositionalLayout { section, environment in
        print("Section \(section)")
        guard let section = Section(rawValue: section) else { return nil }
        
        switch section {
            case .promotions:
                return promotionsSection()
            case .popular:
                return popularSection()
            case .suggestions:
                return suggestionsSection()
        }
    }
    return layout
}

class ViewController: UIViewController, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
            case .promotions:
                return 5
            case .popular:
                return 30
            case .suggestions:
                return 10
        }
    }
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: appStoreLayout()
        )
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.reloadData()
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
}

class CustomCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    let label = UILabel()
    
    private func setup() {
        contentView.backgroundColor = .magenta
        contentView.layer.cornerRadius = 8
        label.text = "Hello"
        label.textColor = .white
        label.sizeToFit()
        contentView.addSubview(label)
        label.center = CGPoint(
            x: contentView.frame.minX + contentView.bounds.size.width * 0.5,
            y: contentView.frame.minY + contentView.bounds.size.height * 0.5
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.center = CGPoint(
            x: contentView.frame.minX + contentView.bounds.size.width * 0.5,
            y: contentView.frame.minY + contentView.bounds.size.height * 0.5
        )
    }
}
