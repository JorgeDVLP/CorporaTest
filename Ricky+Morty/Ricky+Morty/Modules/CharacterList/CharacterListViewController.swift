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
        fetchData()
    }
    
    private func configureCollectionView() {
        self.collectionView.register(CharacterCollectionViewCell.nib(), forCellWithReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier)
        self.collectionView.register(IndicatorCollectionViewCell.self, forCellWithReuseIdentifier: IndicatorCollectionViewCell.reuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.backgroundView = UIView(frame: CGRect.zero)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func bindView() {
        self.viewModel.onDataFetched = { [weak self] count in
            self?.collectionView.reloadData()
            if count > 0 {
                self?.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
        self.viewModel.onDataAdded = { [weak self] rows in
            self?.collectionView.performBatchUpdates { [weak self] in
                self?.collectionView.insertItems(at: rows)
            }
        }
        
        self.viewModel.onShouldDisplayIndicator = { [weak self] display in
            display == true ? self?.showActivityIndicator() : self?.removeActivityIndicator()
        }
    }
    
    private func fetchData() {
        self.viewModel.fetchData()
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
        let count = self.viewModel.numberOfItems(forSection: section)
        return count > 0 ? count + 1 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = self.viewModel.numberOfItems(forSection: indexPath.section)
        
        if indexPath.row == count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndicatorCollectionViewCell.reuseIdentifier, for: indexPath) as! IndicatorCollectionViewCell
            cell.inidicator.startAnimating()
            
            return cell
        }
        
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
        let count = self.viewModel.numberOfItems(forSection: indexPath.section)
        let indicatorCellSize = collectionView.frame.size
        let characterCellWidth = (view.frame.width - 16) / 2
        let size: CGSize = count == indexPath.row ? CGSize(width: indicatorCellSize.width, height: 180) : CGSize(width: characterCellWidth, height: 220)
        return size
    }
}
