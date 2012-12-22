require 'digest/sha2'
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

  validates :name, :presence => true, :length => { :maximum => 23 }
  validates :username, :length => { :maximum => 100, :too_long => 'username is too long (> 100)' }
  validates :decrypted_password, :length => { :maximum => 100, :too_long => 'password is too long (> 100)' }
  validates :url, :length => { :maximum => 100, :too_long => 'url is too long (> 100)' }
  validates :notes, :length => { :maximum => 23, :too_long => 'notes are too long (> 255)' }

  attr_accessible :name, :username, :password, :decrypted_password, :url, :notes, :created_at, :updated_at
  attr_accessor :decrypted_password

  default_scope order_by(:name => :asc)

  def set_decrypted_password(master)
    unless self.password.blank?
      sha512 = Digest::SHA2.new(512)
      salt = sha512.digest(self.id.to_s)
      pass = sha512.digest(master + KEY)
      key = OpenSSL::PKCS5.pbkdf2_hmac(pass, salt, 100000, 16, OpenSSL::Digest::SHA256.new)
      iv = salt[0..15]
      decoded = Base64.decode64(self.password.encode('ascii-8bit'))
      self.decrypted_password = decrypt(decoded, key, iv, "AES-128-CBC")
    end
  end

  def set_password(master)
    if self.decrypted_password
      sha512 = Digest::SHA2.new(512)
      salt = sha512.digest(self.id.to_s)
      pass = sha512.digest(master + KEY)
      key = OpenSSL::PKCS5.pbkdf2_hmac(pass, salt, 100000, 16, OpenSSL::Digest::SHA256.new)
      iv = salt[0..15]
      encrypted_password = encrypt(self.decrypted_password, key, iv, "AES-128-CBC")
      write_attribute :password, Base64.encode64(encrypted_password).encode('utf-8')
    end
  end

  class << self
    def often_used(folders, master)
      records = extract_records_from(folders).sort_by(&:access_count).reverse
      return records[0..2].each {|r| r.set_decrypted_password(master) } if records.length > 3
      records.each {|r| r.set_decrypted_password(master) }
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
