# Users possess roles which either establish them as admins of organizations, or the default role. Users optionally belong to an organization. 
# Users have the validation on email and password. 
# Users have several fields dedicated to authentication and recovery, as well as several datetime fields for record keeping of various User mutating actions.

class User < ApplicationRecord

  enum role: [:admin, :organization]
  after_initialize :set_default_role, :if => :new_record?

  belongs_to :organization, optional: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_presence_of :email
  validates_length_of :email, minimum: 1, maximum: 255, on: :create
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates_uniqueness_of :email, case_sensitive: false
  validates_presence_of :password, on: :create
  validates_length_of :password, minimum: 7, maximum: 255, on: :create

  def set_default_role
    self.role ||= :organization
  end

  def to_s
    email
  end

end
