class baseWrapper:CommandWrapper{
    let service: UIAdapterService
    init(service: UIAdapterService){
        self.service = service
        super.init(parameter: "")
    }
}
