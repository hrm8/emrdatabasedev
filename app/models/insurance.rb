class Insurance < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable
  has_one :address, :dependent => :destroy
  has_many :users

  accepts_nested_attributes_for :address
  
end
