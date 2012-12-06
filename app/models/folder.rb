class Folder
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  embeds_many :records
  accepts_nested_attributes_for :records, :allow_destroy => true, :reject_if => proc {|r| r['name'].blank? }

  field :name, :type => String

  index({ name: 1, user_id: 1, "records.name" => 1 }, { background: true })

  validates_presence_of :name

  attr_accessible :name, :created_at, :updated_at, :user_id, :records_attributes

  default_scope order_by(:name => :asc)
end
