require 'spec_helper'

describe User do

  before do
    @user = FactoryGirl.build(:user, email: 'john.snow@example.com')
  end

  subject { @user }

  [:name, :email, :password, :password_confirmation, :encrypted_password].each do |field|
    it { should respond_to(field) }
  end

  its(:name) { should eq('John') }
  its(:email) { should eq('john.snow@example.com') }
  its(:password) { should eq('my_password') }
  its(:password_confirmation) { should eq('my_password') }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:password_confirmation) }
  it { should allow_mass_assignment_of(:remember_me) }

  it { should_not allow_mass_assignment_of(:encrypted_password) }

  it { should be_valid }

  it { should have_many(:folders).with_dependent(:destroy) }
  it { should respond_to(:folders) }

  it { should have_index_for(email: 1).with_options(unique: true, background: true) }

  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).less_than(30) }

  it { should validate_presence_of(:email) }
  it { should validate_length_of(:email).less_than(100) }

  context "when email is not valid" do
    before { @user.email = 'john.snowexample.com' }

    it { should_not be_valid }
  end

  it "accepts valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(FactoryGirl.attributes_for(:user).merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  context "when a folder is associated" do
    before do
      @user.save
      @user.folders << FactoryGirl.build(:folder)
    end

    it "is persisted" do
      expect { @user.folders << FactoryGirl.build(:folder) }.to change { Folder.count }.from(1).to(2)
    end
  end
end