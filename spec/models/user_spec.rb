require 'spec_helper'

describe User do

  before do
    @user = User.new(name: 'John', email: 'john.snow@example.com', password: 'my_password', password_confirmation: 'my_password')
  end

  subject { @user }

  [:name, :email, :password, :password_confirmation, :encrypted_password].each do |field|
    it { should respond_to(field) }
  end

  it { should respond_to(:folders) }

  its(:name) { should eq('John') }
  its(:email) { should eq('john.snow@example.com') }
  its(:password) { should eq('my_password') }
  its(:password_confirmation) { should eq('my_password') }

  it { should be_valid }

  it "should have many folders" do
    reflection = @user.reflect_on_association(:folders)
    expect(reflection.macro).to eq(:has_many)
  end

  context "when a validation is enforced" do

    context "when name is not present" do
      before { @user.name = nil }

      it { should_not be_valid }
    end

    context "when name is too long" do
      before { @user.name = 'x' * 31 }

      it { should_not be_valid }
    end

    context "when email is too long" do
      before { @user.email = 'x' * 101 }

      it { should_not be_valid }
    end

    context "when email is not valid" do
      before { @user.email = 'john.snowexample.com' }

      it { should_not be_valid }
    end

  end

  context "when a folder is associated" do
    before do
      @user.save
      @user.folders << Folder.new(name: 'my_folder')
    end

    it "should be persisted" do
      expect { @user.folders << Folder.new(name: 'my_folder') }.to change { Folder.count }.from(1).to(2)
    end

    context "when the user is destroyed" do

      it "should destroy the associated folder" do
        expect { @user.delete }.to change { Folder.count }.to(0)
      end

    end
  end
end