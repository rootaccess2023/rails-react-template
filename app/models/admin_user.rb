class AdminUser < ApplicationRecord
# Include default devise modules. Others available are:
# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
       devise :database_authenticatable,
              :recoverable, :rememberable, :validatable

       validates :first_name, :last_name, :email, presence: true
       validates :email, uniqueness: true

       def full_name
              email
       end

       def display_name
              email
       end

       def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "updated_at"]
  end
end
