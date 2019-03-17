class Micropost < ApplicationRecord
  belongs_to :user
  
  validates :content, presence: true, length: { maximum: 255 }
   
  has_many :likerelations, dependent: :destroy
end
