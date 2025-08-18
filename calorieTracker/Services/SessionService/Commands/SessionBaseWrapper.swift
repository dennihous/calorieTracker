class SessionBaseWrapper: CommandWrapper{
    let service: SessionService
    init(service: SessionService){
        self.service = service
        super.init(parameter: "")
    }
}
