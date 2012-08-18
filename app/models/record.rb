class Record
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :folder, inverse_of: :records

  field :name, :type => String
  field :username, :type => String, :default => ""
  field :password, :type => String, :default => ""
  field :url, :type => String, :default => ""
  field :notes, :type => String, :default => ""
  field :access_count, :type => Integer, :default => 0

  validates_presence_of :name

  attr_accessible :name, :username, :password, :url, :notes, :created_at, :updated_at

  default_scope order_by(:name => :asc)
end
