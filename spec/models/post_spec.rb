require 'rails_helper'

RSpec.describe Post, :type => :model do
  let(:post) { FactoryGirl.build(:post) }

  context 'validations' do
    #addhere
    it { expect(post).to validate_presence_of(:title) }
    it { expect(post).to validate_presence_of(:body) }
  end
end
