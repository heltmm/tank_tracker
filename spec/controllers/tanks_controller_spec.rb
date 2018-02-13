# frozen_string_literal: true
require 'rails_helper'

describe TanksController do
  include Devise::Test::ControllerHelpers

  let(:user) { FactoryBot.create(:user)}
  let!(:brewery) { FactoryBot.create(:brewery, user: user) }


  before do
    sign_in user
    5.times do
      FactoryBot.create(:tank, brewery: brewery)
    end
    5.times do
      FactoryBot.create(:bbt_tank, brewery: brewery)
    end
  end

  describe 'celler update tank status' do
    let(:tank) { FactoryBot.create(:tank, brewery: brewery) }
    let(:tank_attrs) do
      {
        number: tank.number,
        tank_type: tank.tank_type
      }
    end

    it 'from dirty to clean' do
      tank_attrs[:status] = :clean
      put 'cellar_update', params: { tank: tank_attrs }
      expect(Tank.find(tank.id).status).to eq('clean')
    end

    it 'from clean to stanitized' do
      tank.clean!
      tank_attrs[:status] = :sanitized
      put 'cellar_update', params: { tank: tank_attrs }
      expect(Tank.find(tank.id).status).to eq('sanitized')
    end

    it 'from active to dirty' do
      tank.status = :active
      tank.save
      tank_attrs[:status] = :dirty
      put 'cellar_update', params: { tank: tank_attrs }
      expect(Tank.find(tank.id).status).to eq('dirty')
    end

    it 'will not change from dirty to sanized' do
      tank_attrs[:status] = :sanitized
      put 'cellar_update', params: { tank: tank_attrs }
      expect(Tank.find(tank.id).status).to eq('dirty')
    end

    it 'will not change from active to sanitized' do
      tank.status = :active
      tank.save
      tank_attrs[:status] = :sanitized
      put 'cellar_update', params: { tank: tank_attrs }
      expect(Tank.find(tank.id).status).to eq('active')
    end
  end

  describe 'brewer update tank' do
    let(:tank) { FactoryBot.create(:tank, brewery: brewery) }

    let(:tank_attrs) do
      {
        brand: 'Fresh Squeezed',
        gyle: 2001,
        volume: 100,
        number: tank.number,
        tank_type: tank.tank_type
      }
    end

    it 'will change from sanitized to active' do
      tank.status = :sanitized
      tank.save
      put 'brewer_update', params: { tank: tank_attrs }
      expect(Tank.find(tank.id).status).to eq('active')
    end

    it 'will not change from dirty to active' do
      put 'brewer_update', params: { tank: tank_attrs }
      expect(Tank.find(tank.id).status).to eq('dirty')
    end

    it 'will not change from clean to active' do
      tank.status = :clean
      tank.save
      put 'brewer_update', params: { tank: tank_attrs }
      expect(Tank.find(tank.id).status).to eq('clean')
    end

    it 'will update tank brand, gyle, volume, brew date' do
      tank.status = :sanitized
      tank.save
      put 'brewer_update', params: { tank: tank_attrs }
      expect(Tank.find(tank.id).brand).to eq('Fresh Squeezed')
      expect(Tank.find(tank.id).gyle).to eq(2001)
      expect(Tank.find(tank.id).volume).to eq(100)
    end
  end

  describe 'packaging update tank' do
    let(:tank) { FactoryBot.create(:tank, brewery: brewery) }

    it 'from active to sanitized refill' do
      tank.status = "active"
      tank.save
      put 'package_update', params: { tank: { number: tank.number, tank_type: tank.tank_type, refill: true } }
      expect(Tank.find(tank.id).status).to eq('sanitized')
      expect(Tank.find(tank.id).refill_count).to eq(1)
    end

    it 'removes volume from tank' do
      active_tank = FactoryBot.create(:active_tank, brewery: brewery)

      put 'package_update', params: { tank: { number: active_tank.number, tank_type: active_tank.tank_type, volume: 20 } }

      expect(Tank.find(active_tank.id).volume).to eq(80)
    end

    it 'will not remove more volume than there is' do
      active_tank = FactoryBot.create(:active_tank, brewery: brewery)

      put 'package_update', params: { tank: { number: active_tank.number, tank_type: active_tank.tank_type, volume: 120 } }

      expect(Tank.find(active_tank.id).volume).to eq(100)
    end
  end
end
