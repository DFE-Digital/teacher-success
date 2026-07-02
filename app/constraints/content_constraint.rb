class ContentConstraint
  def self.matches?(request)
    !request.path.include?("/rails/active_storage")
  end
end
