require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:social_networks).dependent(:destroy) }

  describe '#author_of' do
    let(:author) { create(:user) }
    let(:current_user) { create(:user) }
    let(:question) { create(:question_author, author: author) }
    let(:answer) { create(:answer, question: question, author: author) }
    context 'item\'s author and user are the same' do
      it 'compares question\'s author and user' do
        expect(author).to be_author_of(question)
      end

      it 'compares answer\'s author and user' do
        expect(author).to be_author_of(answer)
      end
    end

    context 'item\'s author and user are different' do
      it 'compares question\'s author and user' do
        expect(current_user).to_not be_author_of(question)
      end

      it 'compares answer\'s author and user' do
        expect(current_user).to_not be_author_of(answer)
      end
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has social_network' do
      it 'returns user' do
        user.social_networks.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no social network' do

      context 'provider did not return email' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { email: '' }) }

        it 'returns nil user' do
          expect(User.find_for_oauth(auth).id).to eq nil
        end

        it 'does not create social network' do
          expect { User.find_for_oauth(auth) }.to_not change(SocialNetwork, :count)
        end
        
        it 'does not create user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end
      end

      context 'user is going to confirm new email' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { email: 'test@email.com' }, confirmation: true) }

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'creates social network' do
          expect { User.find_for_oauth(auth) }.to change(SocialNetwork, :count).by(1)
        end

        it 'creates social network with uid and provider' do
          social_network = User.find_for_oauth(auth).social_networks.first

          expect(social_network.provider).to eq auth.provider
          expect(social_network.uid).to eq auth.uid.to_s
        end

        it 'creates user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'creates user with e-mail' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq 'test@email.com'
        end

        it 'creates unconfirmed user' do
          user = User.find_for_oauth(auth)
          expect(user.confirmed?).to be false
        end
      end

      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates social_network for user' do
          expect { User.find_for_oauth(auth) }.to change(SocialNetwork, :count).by(1)
        end

        it 'creates social_network with provider and uid' do
          social_network = User.find_for_oauth(auth).social_networks.first

          expect(social_network.provider).to eq auth.provider
          expect(social_network.uid).to eq auth.uid.to_s
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@email.com' }) }

        it 'creates new user' do
          expect{ User.find_for_oauth(auth)}.to change(User, :count).by(1)
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills in user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates new social_network' do
          user = User.find_for_oauth(auth)
          expect(user.social_networks).to_not be_empty
        end

        it 'creates social_network with correct provider and uid' do
          social_network = User.find_for_oauth(auth).social_networks.first

          expect(social_network.provider).to eq auth.provider
          expect(social_network.uid).to eq auth.uid.to_s
        end
      end
    end
  end
end
