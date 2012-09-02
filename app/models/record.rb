require 'aescrypt'

class Record
  include Mongoid::Document
  include Mongoid::Timestamps

  include AESCrypt

  embedded_in :folder, inverse_of: :records

  field :name, :type => String
  field :username, :type => String, :default => ""
  field :password, :type => String, :default => ""
  field :url, :type => String, :default => ""
  field :notes, :type => String, :default => ""
  field :access_count, :type => Integer, :default => 0

  validates_presence_of :name

  attr_accessible :name, :username, :password, :decrypted_password, :url, :notes, :created_at, :updated_at
  attr_accessor :decrypted_password

  after_validation :set_password

  default_scope order_by(:name => :asc)

  def set_decrypted_password
    unless self.password.blank?
      iv = self.folder.user.created_at.to_i.to_s[0..7] * 2
      decoded = Base64.decode64(self.password.encode('ascii-8bit'))
      self.decrypted_password = decrypt(decoded, KEY, iv, "AES-256-CBC")
    end
  end

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

  private
    def set_password
      if self.decrypted_password
        iv = self.folder.user.created_at.to_i.to_s[0..7] * 2
        encrypted_password = encrypt(self.decrypted_password, KEY, iv, "AES-256-CBC")
        write_attribute :password, Base64.encode64(encrypted_password).encode('utf-8')
      end
    end
end
