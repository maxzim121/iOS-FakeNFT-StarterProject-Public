import UIKit

final class StatisticsCell: UITableViewCell {
    static let reuseIdentifier = "StatisticsViewCell"
    
    private var task: URLSessionDataTask?
    private var userAvatarStub = UIImage(named: "userAvatarStub")
    private lazy var grayField: UIView = {
       let grayField = UIView()
        grayField.translatesAutoresizingMaskIntoConstraints = false
        grayField.backgroundColor = .segmentInactive
        grayField.layer.masksToBounds = true
        grayField.layer.cornerRadius = 12
       return grayField
    }()
    
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 14
        imageView.image = userAvatarStub
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .headline3
        label.textColor = .segmentActive
        return label
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .headline3
        label.textColor = .segmentActive
        return label
    }()
    
    lazy var userRating: UILabel = {
        let userRating = UILabel()
        userRating.translatesAutoresizingMaskIntoConstraints = false
        userRating.font = .caption1
        userRating.textAlignment = .center
        userRating.textColor = .segmentActive
        //userRating.text = "1"
        return userRating
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(userRating)
        contentView.addSubview(grayField)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            userRating.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userRating.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userRating.trailingAnchor.constraint(lessThanOrEqualTo: grayField.leadingAnchor),
            
            //grayField.leadingAnchor.constraint(equalTo: number.trailingAnchor, constant: 8)
            ])
    }
}
