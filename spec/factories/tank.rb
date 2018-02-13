# frozen_string_literal: true
FactoryBot.define do
  factory :tank do
    tank_type "FV"
    brewery
    sequence(:number)
  end

  factory :bbt_tank, class: Tank, parent: :tank do
    tank_type "BBT"
  end

  factory :active_tank, class: Tank, parent: :tank do
    gyle 2001
    brand "Fresh Squeezed"
    volume 100
    date_brewed Time.now
  end
end
