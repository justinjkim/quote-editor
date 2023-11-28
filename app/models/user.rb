class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable
  # For now, we will comment out the below Devise modules since we just need
  # users in our seeds and a way to login.
  # :recoverable, :rememberable, :validatable

  belongs_to :company
end
