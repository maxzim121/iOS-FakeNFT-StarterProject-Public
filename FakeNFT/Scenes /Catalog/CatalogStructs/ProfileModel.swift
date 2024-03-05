import Foundation

public struct ProfileModel {
    let name: String
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [NftModel]
    let likes: [NftModel]
    let id: String
}
