class User
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :folders, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # and :omniauthable
  devise :database_authenticatable, :registerable, :lockable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ email: 1 }, { unique: true, background: true })

  field :name, :type => String

  validates :name, :presence => :true, :length => { :maximum => 30, :too_long => 'is too long (> 30)' }
  validates :email, :length => { :maximum => 100, :too_long => 'is too long (> 100)' }

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at
end
