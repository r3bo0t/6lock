class Folder
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  embeds_many :records
  accepts_nested_attributes_for :records, :allow_destroy => true, :reject_if => proc {|r| r['name'].blank? }

  field :name, :type => String

  index({ name: 1, user_id: 1, "records.name" => 1 }, { background: true })

  validates :name, :presence => true, :length => { :maximum => 23 }

  attr_accessible :name, :created_at, :updated_at, :records_attributes

  default_scope order_by(:name => :asc)
end
