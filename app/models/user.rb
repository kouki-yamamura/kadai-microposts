class User < ApplicationRecord
     before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts
   
  has_many :likerelations
  has_many :likings, through: :likerelations, source: :micropost
  
  
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
   
   
   def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
   end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  
#お気に入りをする 
  def like(micropost)
    self.likerelations.find_or_create_by(micropost_id: micropost.id)
  end 
#お気に入りを解除する  
  def unlike(micropost)
    likerelation = self.likerelations.find_by(micropost_id: micropost.id)
    likerelation.destroy if likerelation
  end
  
# お気に入りを取得し、micropostが含まれていればtrueを返す
  def liking?(micropost)
    self.likings.include?(micropost)
  end
end
