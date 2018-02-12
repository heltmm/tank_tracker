# frozen_string_literal: true
require 'spec_helper'

describe TanksController do
  let(:user) { FactoryBot.create(:user) }
  let(:brewery) { FactoryBot.create(:brewery) }

  before do
    sign_in user
  end

  describe 'Find Tank by number and type' do
    it 'should return a corect tank' do

        put 'brewer_update', id: 
    end
  end
end
