import Foundation

struct User:Identifiable, Codable {
    var id: String
    var username: String
    var email: String
    
    // 手机号
    var phoneNumber : String    // 用户手机号
    var isPhoneVerified: Bool // 是否已通过手机号验证
    
    // 对于验证码，一般不建议持久化在 User 模型中，而是“临时”或仅在 Server 端记录
    // 但如果需要在本地表示验证码状态，可加上一个可选值
    var verificationCode: String? // 验证码（仅在注册/验证阶段临时使用，通常不会长期保存在数据库）
    
    // 角色
    var role: UserRole
    
    // 创建时间
    var createdAt: String
    
    // 设备列表
    var ownedDevices: [String]
    
    // 其他
    var avatarUrl: String? // 头像URL
    
    
}

// 定义角色的枚举类型，方便判断用户权限的
enum UserRole: String, Codable {
    case owner       // 拥有者/房主
    case admin       // 管理员
    case member      // 家庭成员
    case guest       // 访客
}
