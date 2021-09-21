class Book < ApplicationRecord
	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :favorited_users, through: :favorites, source: :user
	has_many :book_comments, dependent: :destroy
  has_many  :tag_relationships, dependent: :destroy
  has_many  :tags, through: :tag_relationships

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

  is_impressionable

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_one_day_ago, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_two_day_ago, -> { where(created_at: 2.day.ago.all_day) }
  scope :created_three_day_ago, -> { where(created_at: 3.day.ago.all_day) }
  scope :created_four_day_ago, -> { where(created_at: 4.day.ago.all_day) }
  scope :created_five_day_ago, -> { where(created_at: 5.day.ago.all_day) }
  scope :created_six_day_ago, -> { where(created_at: 6.day.ago.all_day) }

  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}

  def self.search(search)
    if search
      Tag.where(['name LIKE ?', "%#{search}%"])
    else
      Tag.all
    end
  end

  def save_tags(savebook_tags)
      savebook_tags.each do |new_name|
      book_tag = Tag.find_or_create_by(name: new_name)
      self.tags << book_tag
    end
  end
end

