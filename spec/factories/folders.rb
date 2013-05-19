FactoryGirl.define do
  factory :folder do
    name 'my_folder'
    user

    factory :folder_with_records do
      records { [FactoryGirl.create(:record), FactoryGirl.create(:record, position: 1)] }
    end

    factory :folder_with_records2 do
      records { [FactoryGirl.create(:record), FactoryGirl.create(:record, position: 2)] }
    end
  end
end