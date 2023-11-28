class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :validatable
  # For now, we will comment out the below Devise modules since we just need
  # users in our seeds and a way to login.
  # :recoverable, :rememberable, :registerable

  belongs_to :company

  def name
    email.split("@").first.capitalize
  end
end
