class Clinic < ApplicationRecord
  has_one :address, :dependent => :destroy
  has_many :share_requests, :dependent => :destroy
  has_many :owned_records, :class_name => 'Record', foreign_key: 'clinic_id'
  has_and_belongs_to_many :records

  def login

  end

  def records

  end

  def upload_file
    
  end

end
