class Building < ApplicationRecord
  has_many :addresses
  has_many :costs
  has_many :stations
  belongs_to :structure
end
