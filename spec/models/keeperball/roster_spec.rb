require 'rails_helper'

module Keeperball
  describe Roster do
    it_should_behave_like Seasonable, { name: 'Shisland' }
  end
end
