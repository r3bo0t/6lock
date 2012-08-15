class Folder
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  embeds_many :files

  field :name, :type => String

  index({ name: 1, user_id: 1, "files.name" => 1, "files.access_count" => 1 }, { background: true })

  validates_presence_of :name

  attr_accessible :name, :created_at, :updated_at
end
