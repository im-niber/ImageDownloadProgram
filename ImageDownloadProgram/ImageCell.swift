import UIKit

final class ImageCell: UICollectionViewCell {
    static let identifier = "ImageCell"
    
    private var imageRequestTask: Task<Void, Never>?
    
    private(set) lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "photo")
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var slider: UIProgressView = {
        let view = UIProgressView()
        view.progressTintColor = .blue
        view.setProgress(0.5, animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var button: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 10
        view.backgroundColor = .blue
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Load", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addTarget(self, action: #selector(reloadImage), for: .touchUpInside)
                
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [imageView, slider, button].forEach({ view in
            self.addSubview(view)
        })
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            
            slider.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            slider.trailingAnchor.constraint(equalTo: button.leadingAnchor),
            slider.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            button.widthAnchor.constraint(equalToConstant: 50),
            button.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    @objc private func reloadImage() {
        imageView.image = UIImage(systemName: "photo")
        let url = URL(string: "https://source.unsplash.com/random")
        let request = URLRequest(url: url!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            let image = UIImage(data: data)
            self.imageRequestTask = Task {
                self.imageView.image = image
            }
        }.resume()
    }
}
