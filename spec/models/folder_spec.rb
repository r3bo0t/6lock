require 'spec_helper'

describe Folder do

  before do
    @folder = Folder.new(name: 'my_folder')
  end

  subject { @folder }

  it { should respond_to(:name) }

  it { should respond_to(:user) }
  it { should respond_to(:records) }

  its(:name) { should eq('my_folder') }

  it { should be_valid }

  context "when the associations are set up" do
    it "should belong to a user" do
      reflection = @folder.reflect_on_association(:user)
      expect(reflection.macro).to eq(:belongs_to)
    end

    it "should embed many records" do
      reflection = @folder.reflect_on_association(:records)
      expect(reflection.macro).to eq(:embeds_many)
    end
  end

  context "when a validation is enforced" do
    context "when name is not present" do
      before { @folder.name = nil }

      it { should_not be_valid }
    end

    context "when name is too long" do
      before { @folder.name = 'x' * 24 }

      it { should_not be_valid }
    end
  end

  context "when multuple folders are saved and retrieved" do
    let(:folders) { Folder.all }

    before do
      @folder.save
      Folder.new(name: 'a').save
      Folder.new(name: 'z').save
    end

    it "should order folders by ascending name" do
      expect(folders.first.name).to eq('a')
      expect(folders.last.name).to eq('z')
    end
  end

end