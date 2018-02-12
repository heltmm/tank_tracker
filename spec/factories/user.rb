# frozen_string_literal: true
FactoryBot.define do
  factory :user do |f|
    f.username "Joe"
    f.password 'password'
    f.password_confirmation 'password'
  end
end
