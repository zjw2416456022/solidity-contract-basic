contract UserManagementSystem {
    //TODO:定义User结构体
    struct User {
        string name;
        string email;
        uint256 balance;
        uint256 registeredAt;
        bool exists;
    }
    mapping(address => User) public users;
    
    constructor() {
        
    }
}