import UIKit

final class StatisticsCell: UITableViewCell {
    static let reuseIdentifier = "StatisticsViewCell"

    private var task: URLSessionDataTask?

    private lazy var userRating: UILabel = {
        let userRating = UILabel()
        userRating.font = .caption1
        userRating.textAlignment = .center
        userRating.textColor = .yaBlackLight
        return userRating
    }()

    private lazy var grayField: UIView = {
       let grayField = UIView()
        grayField.backgroundColor = .segmentInactive
        grayField.layer.masksToBounds = true
        grayField.layer.cornerRadius = 12
       return grayField
    }()

    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 14
        return imageView
    }()

    private var userAvatarStub = UIImage(named: "userAvatarStub")

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .yaBlackLight
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .yaBlackLight
        return label
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

    func configure(user: UserProfile) {
        userRating.text = "\(user.rating)"

        let url = URL(string: user.avatar)
        avatarView.kf.indicatorType = .activity
        avatarView.kf.setImage(with: url, placeholder: userAvatarStub)

        nameLabel.text = user.name

        nftCountLabel.text = "\(user.nfts.count)"

    }
    private func setupUI() {
        [userRating,
         grayField,
         avatarView,
         nameLabel,
         nftCountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            userRating.heightAnchor.constraint(equalToConstant: 20),
            userRating.widthAnchor.constraint(equalToConstant: 27),
            userRating.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userRating.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            grayField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            grayField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            grayField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            grayField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            avatarView.heightAnchor.constraint(equalToConstant: 28),
            avatarView.widthAnchor.constraint(equalToConstant: 28),
            avatarView.topAnchor.constraint(equalTo: grayField.topAnchor, constant: 26),
            avatarView.leadingAnchor.constraint(equalTo: grayField.leadingAnchor, constant: 16),

            nameLabel.widthAnchor.constraint(equalToConstant: 186),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.topAnchor.constraint(equalTo: grayField.topAnchor, constant: 26),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),

            nftCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
