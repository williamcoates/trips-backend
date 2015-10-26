class Trip < ActiveRecord::Base
  belongs_to :user
  validates :end_date, date: { after_or_equal_to: :start_date }

  def has_access?(user)
    user.admin? || self.user == user
  end
end
