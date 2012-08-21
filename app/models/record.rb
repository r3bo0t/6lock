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

  class << self
    def often_used(folders)
      records = extract_records_from(folders).sort_by(&:access_count).reverse
      records[0..2] if records.length > 3
    end

    def get_record_from(folders, record_id)
      records = extract_records_from(folders)
      records.select {|r| r.id.to_s == record_id}.first
    end

    def extract_records_from(folders)
      records = []
      folders.each {|f| records << f.records}
      records.flatten
    end
  end
end
