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
        label.textColor = .yaBlackLight
        label.text = "Alex"
        return label
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .headline3
        label.textColor = .yaBlackLight
        label.text = "100"
        return label
    }()
    
    lazy var userRating: UILabel = {
        let userRating = UILabel()
        userRating.translatesAutoresizingMaskIntoConstraints = false
        userRating.font = .caption1
        userRating.textAlignment = .center
        userRating.textColor = .yaBlackLight
        userRating.text = "1"
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
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nftCountLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            userRating.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userRating.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userRating.trailingAnchor.constraint(lessThanOrEqualTo: grayField.leadingAnchor),
            
            grayField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            grayField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            grayField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            grayField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            avatarView.heightAnchor.constraint(equalToConstant: 28),
            avatarView.widthAnchor.constraint(equalToConstant: 28),
            avatarView.topAnchor.constraint(equalTo: grayField.topAnchor, constant: 26),
            avatarView.leadingAnchor.constraint(equalTo: grayField.leadingAnchor, constant: 16),
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.topAnchor.constraint(equalTo: grayField.topAnchor, constant: 26),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            
            nftCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
    }
}
