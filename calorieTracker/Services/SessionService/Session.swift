class Session{
    var userID: Optional<String> = nil
    var foods: Optional<Dictionary<String, Dictionary<String.Any>>> = nil
    init(userID: String){
        self.userID = userID
    }
}
