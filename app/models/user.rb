# User model used by Devise, with an additional access_level colum
# dictating the users access rights
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable
  enum access_level: [:user, :admin]
end
