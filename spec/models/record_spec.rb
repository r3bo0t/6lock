require 'spec_helper'

describe Record do

  before do
    @record = Record.new(name: 'Gmail', username: 'john.snow@example.com', url: 'http://mail.google.com', notes: 'Gmail is cool')
  end

  subject { @record }

  [:name, :username, :password, :decrypted_password, :url, :notes, :position].each do |field|
    it { should respond_to(field) }
  end

  [:set_decrypted_password, :set_password, :folder_id, :move_to_folder].each do |instance_method|
    it { should respond_to(instance_method) }
  end

  [:often_used, :get_record_from, :extract_records_from, :to_csv].each do |class_method|
    its(:class) { should respond_to(class_method) }
  end

  it { should respond_to(:folder) }

  its(:name) { should eq('Gmail') }
  its(:username) { should eq('john.snow@example.com') }
  its(:url) { should eq('http://mail.google.com') }
  its(:notes) { should eq('Gmail is cool') }

  it { should be_valid }

  it "is embedded in a folder" do
    reflection = @record.reflect_on_association(:folder)
    expect(reflection.macro).to eq(:embedded_in)
  end

  context "when a validation is enforced" do
    context "when name is not present" do
      before { @record.name = nil }

      it { should_not be_valid }
    end

    context "when name is too long" do
      before { @record.name = 'x' * 24 }

      it { should_not be_valid }
    end

    context "when username is too long" do
      before { @record.username = 'x' * 101 }

      it { should_not be_valid }
    end

    context "when decrypted_password is too long" do
      before { @record.decrypted_password = 'x' * 101 }

      it { should_not be_valid }
    end

    context "when url is too long" do
      before { @record.url = 'x' * 101 }

      it { should_not be_valid }
    end

    context "when notes are too long" do
      before { @record.notes = 'x' * 256 }

      it { should_not be_valid }
    end
  end

  it "does not mass assigns position" do
    expect(Record.accessible_attributes).not_to include('position')
  end

  describe "#folder_id" do
    let(:folder) { Folder.new() }

    before { folder.records << @record }

    it "returns the embedding folder id" do
      expect(@record.folder_id).to eq(folder.id)
    end
  end

  describe "#move_to_folder" do
    let(:folder) { Folder.new() }
    let(:new_folder) { Folder.new() }

    before { folder.records << @record }

    it "changes the record folder" do
      expect(@record.move_to_folder(new_folder, 'master_password').folder_id).to eq(new_folder.id)
    end
  end

  context "when decrypted_password is present" do
    before { @record.decrypted_password = 'my_password' }

    context "when the decrypted_password is encrypted" do
      let(:master_password) { 'master_password' }

      before { @record.set_password(master_password) }

      it "decrypts the encrypted password" do
        expect(@record.set_decrypted_password(master_password)).to eq('my_password')
      end
    end
  end

  context "when multiple folders contain records" do
    let(:first_folder) { Folder.new() }
    let(:second_folder) { Folder.new() }
    let(:record) { Record.new() }
    let(:second_record) { Record.new() }
    let(:third_record) { Record.new() }
    let(:folders) { [first_folder, second_folder] }

    before do
      second_record.position, third_record.position = 2, 1
      first_folder.records << @record << second_record
      second_folder.records << record << third_record
    end

    describe ".extract_records_from" do
      it "extracts records from a folder list" do
        expect(Record.extract_records_from(folders)).to include(@record, record)
      end
    end

    describe ".get_record_from" do
      it "gets a record with corresponding id" do
        expect(Record.get_record_from(folders, record.id.to_s)).to eq(record)
      end
    end

    describe ".often_used" do
      it "gets records that have a position" do
        expect(Record.often_used(folders, 'master_password')).to include(second_record, third_record)
      end

      it "does not get records that do not have a position" do
        expect(Record.often_used(folders, 'master_password')).not_to include(@record, record)
      end

      it "orders record according to their position" do
        expect(Record.often_used(folders, 'master_password')).to start_with(third_record)
        expect(Record.often_used(folders, 'master_password')).to end_with(second_record)
      end
    end
  end

end