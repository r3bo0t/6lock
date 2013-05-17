require 'digest/sha2'
require 'aescrypt'
require 'csv'

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
  field :position, :type => Integer, :default => nil

  validates :name, :presence => true, :length => { :maximum => 23 }
  validates :username, :length => { :maximum => 100, :too_long => 'username is too long (> 100)' }
  validates :decrypted_password, :length => { :maximum => 100, :too_long => 'password is too long (> 100)' }
  validates :url, :length => { :maximum => 100, :too_long => 'url is too long (> 100)' }
  validates :notes, :length => { :maximum => 255, :too_long => 'notes are too long (> 255)' }

  attr_accessible :name, :username, :decrypted_password, :url, :notes, :created_at, :updated_at
  attr_accessor :decrypted_password

  def set_decrypted_password(master)
    unless self.password.blank?
      sha512 = Digest::SHA2.new(512)
      salt = sha512.digest(self.id.to_s)
      pass = sha512.digest(master + KEY)
      key = OpenSSL::PKCS5.pbkdf2_hmac(pass, salt, 100000, 32, OpenSSL::Digest::SHA256.new)
      iv = salt[0..15]
      decoded = Base64.decode64(self.password.encode('ascii-8bit'))
      self.decrypted_password = decrypt(decoded, key, iv, "AES-256-CBC")
    end
  end

  def set_password(master)
    if self.decrypted_password
      sha512 = Digest::SHA2.new(512)
      salt = sha512.digest(self.id.to_s)
      pass = sha512.digest(master + KEY)
      key = OpenSSL::PKCS5.pbkdf2_hmac(pass, salt, 100000, 32, OpenSSL::Digest::SHA256.new)
      iv = salt[0..15]
      encrypted_password = encrypt(self.decrypted_password, key, iv, "AES-256-CBC")
      write_attribute :password, Base64.encode64(encrypted_password).encode('utf-8')
    end
  end

  # only for the collection_select needs
  def folder_id
    self.folder.id
  end

  def move_to_folder(folder, master)
    pass = set_decrypted_password(master)
    new_record = dup
    destroy
    new_record.tap do |new_r|
      folder.records << new_r
      new_r.decrypted_password = pass
      new_r.set_password(master)
      new_r.save
    end
  end

  class << self
    def often_used(folders, master)
      records = extract_records_from(folders)
      records.select(&:position).sort_by(&:position).each {|r| r.set_decrypted_password(master) }
    end

    def get_record_from(folders, record_id)
      records = extract_records_from(folders)
      records.select {|r| r.id.to_s == record_id }.first
    end

    def extract_records_from(folders)
      records = []
      folders.each {|f| records << f.records }
      records.flatten
    end

    def to_csv(records)
      CSV.generate do |csv|
        csv << ['name', 'username', 'decrypted_password', 'url', 'notes']
        records.each do |record|
          csv << record.attributes.values_at('name', 'username') + record.decrypted_password.to_a + record.attributes.values_at('url', 'notes')
        end
      end
    end
  end
end
