require 'spec_helper'

describe Folder do

  before do
    @folder = FactoryGirl.build(:folder)
  end

  subject { @folder }

  it { should respond_to(:name) }

  it { should belong_to(:user) }
  it { should respond_to(:user) }

  it { should embed_many(:records) }
  it { should respond_to(:records) }

  its(:name) { should eq('my_folder') }

  it { should allow_mass_assignment_of(:name) }

  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).less_than(23) }

  it { should be_valid }

  it { should accept_nested_attributes_for(:records) }

  it { should have_index_for(name: 1, user_id: 1, 'records.name' => 1).with_options(background: true) }

  context "when multuple folders are saved and retrieved" do
    let(:folders) { Folder.all }

    before do
      @folder.save
      Folder.new(name: 'a').save
      Folder.new(name: 'z').save
    end

    it "orders folders by ascending name" do
      expect(folders.first.name).to eq('a')
      expect(folders.last.name).to eq('z')
    end
  end

end