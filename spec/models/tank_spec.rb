require 'rails_helper'

describe Tank, 'validation' do
  it { should validate_presence_of :tank_type }
  it { should validate_presence_of :number }
end

describe Tank, 'association' do
  it { should belong_to :brewery }
end

describe Tank, 'column_specification' do
  it { should have_db_column(:brewery_id).of_type(:integer) }
  it { should have_db_column(:tank_type).of_type(:string) }
  it { should have_db_column(:number).of_type(:integer) }
  it { should have_db_column(:status).of_type(:string) }
  it { should have_db_column(:gyle).of_type(:integer) }
  it { should have_db_column(:brand).of_type(:string) }
  it { should have_db_column(:volume).of_type(:integer) }
  it { should have_db_column(:dryhopped).of_type(:boolean) }
  it { should have_db_column(:last_acid).of_type(:date) }
  it { should have_db_column(:date_brewed).of_type(:date) }
  it { should have_db_column(:date_filtered).of_type(:date) }
  it { should have_db_column(:initials).of_type(:string) }
end
