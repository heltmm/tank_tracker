require 'rails_helper'

describe Brewery, 'validation' do
  it { should validate_presence_of :name }
end

describe Brewery, 'association' do
  it { should belong_to :user }
end

describe Brewery, 'column_specification' do
  it { should have_db_column(:user_id).of_type(:integer) }
  it { should have_db_column(:name).of_type(:string) }

end
