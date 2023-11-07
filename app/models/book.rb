class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :week_favorites, -> { where(created_at: 1.week.ago.beginning_of_day..Time.current.end_of_day) }
  # :week_favorites 関連付けの名前を定義します。
  # -> { ... } 関連付けに特定の条件を指定することができます。関連するデータを絞り込んだり、条件を満たすデータのみを取得するために使います。
  # created_at カラムが指定した期間に該当するデータのみを取得します。
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
