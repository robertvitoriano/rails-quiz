class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(level = "user", id)
    @level = level
    @user_id = id
  end

  def call
    user
  end

  private

  attr_reader :level


  def user
    if(@level== "admin")
      @user ||= User.where({id: @user_id, level:"admin"})[0]
    elsif(@level == "user")
      @user ||= User.where({id: @user_id})[0]
    end
  end


end
