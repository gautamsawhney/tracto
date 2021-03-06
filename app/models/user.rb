class User < ActiveRecord::Base
  enum roles: [:admin, :restaurant_owner, :mod]
  # Autocode: Callback
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup.except(:password)
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
    # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable

  # Autocode: Relationships
  has_many :comments
  has_many :posts
  has_many :restaurants

  has_many :authtokens, dependent: :destroy
  has_many :identities, dependent: :destroy

  # File Upload
  has_attached_file :image

  # Autocode: Validations
  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => /./
  # You can change the content type as follows
  # Image: /Aimage/.*Z/
  # Audio: /Aaudio/.*Z/
  # Video: /Avideo/.*Z/
  validates_presence_of :name

  validates_presence_of   :email, if: :email_required?
  validates_uniqueness_of :email, allow_blank: true, if: :email_changed?
  validates_format_of     :email, with: Devise.email_regexp, allow_blank: true, if: :email_changed?

  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: Devise.password_length, allow_blank: true

  validates_presence_of     :password_confirmation, if: :password_required?
  validates_confirmation_of :password_confirmation, if: :password_required?

  # Soft Destroy

  def password_required?
    return false if email.blank?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def email_required?
    true
  end

end
