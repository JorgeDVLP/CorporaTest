//
//  CharacterListViewController.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import UIKit

class CharacterListViewController: UIViewController, StoryBoarded {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterControl: UISegmentedControl!
    
    weak var eventDelegate: CharacterListEventDelegate?
    var viewModel: CharacterListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Characters"
        configureCollectionView()
        bindView()
        self.viewModel.fetchData()
    }
    
    private func configureCollectionView() {
        self.collectionView.register(CharacterCollectionViewCell.nib(), forCellWithReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.backgroundView = UIView(frame: CGRect.zero)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func bindView() {
        self.viewModel.onDataFetched = { count in
            self.collectionView.reloadData()
            if count > 0 {
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
        self.viewModel.onDataAdded = { rows in
            self.collectionView.performBatchUpdates { [weak self] in
                self?.collectionView.insertItems(at: rows)
            }
        }
    }
    
    @IBAction func onFilterChanged() {
        self.viewModel.onFilterChanged(index: self.filterControl.selectedSegmentIndex)
    }
}

extension CharacterListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems(forSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier, for: indexPath) as? CharacterCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = viewModel.getItem(forIndex: indexPath)
        cell.nameLabel.text = item.name
        cell.statusLabel.text = item.status.rawValue
        cell.originLabel.text = item.origin
        
        switch item.status {
        case .alive:
            cell.statusLabel.textColor = UIColor(named: "GreenColor")
        case .dead:
            cell.statusLabel.textColor = UIColor.red
        case .unknown:
            cell.statusLabel.textColor = UIColor.gray
        }
        
        let representableID = item.id
        cell.representableID = representableID
        
        ImageCache.loadImage(urlString: item.imageURL) { image in
            if cell.representableID == representableID {
                cell.image.image = image
            }
        }
        
        return cell
    }
}

extension CharacterListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let limit = self.collectionView.contentSize.height - 100 - scrollView.frame.size.height
        if position > limit {
            self.viewModel.fetchNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.viewModel.getItem(forIndex: indexPath)
        print("Selected item", item)
        self.eventDelegate?.onCharacterSelected(item)
    }
}

extension CharacterListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 16) / 2
        return CGSize(width: width, height: 220)
    }
}
