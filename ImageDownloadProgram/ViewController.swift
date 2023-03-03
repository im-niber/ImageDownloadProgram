import UIKit

final class ViewController: UIViewController {
    
    private var imageRequestTask: Task<Void, Never>?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private lazy var button: UIButton = {
        let view = UIButton()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 10
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Load All Images", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addTarget(self, action: #selector(reloadImages), for: .touchUpInside)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        
        layout()
    }
    
    private func layout() {
        view.addSubview(collectionView)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            button.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 5 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UICollectionViewCell()}
        cell.id = indexPath
        let url = URL(string: "https://picsum.photos/200")

        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            let image = UIImage(data: data)
            self.imageRequestTask = Task {
                guard cell.id == indexPath, cell.imageView.image == UIImage(systemName: "photo") else { return }
                cell.imageView.image = image
            }
        }.resume()
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

extension ViewController {
    @objc func reloadImages() {
        collectionView.visibleCells.forEach { cell in
            guard let cell = cell as? ImageCell else { return }
            cell.imageView.image = UIImage(systemName: "photo")
            let url = URL(string: "https://picsum.photos/200")

            let request = URLRequest(url: url!)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else { return }
                let image = UIImage(data: data)
                self.imageRequestTask = Task {
                    cell.imageView.image = image
                }
            }.resume()
        }
    }
}

