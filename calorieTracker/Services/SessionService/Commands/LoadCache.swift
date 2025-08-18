class LoadCache: SessionBaseWrapper{
    override func execute()->Optional<Any>{
        let message: message = self.parameter as! message
        return self.service.loadCache(message: message)
    }
}
