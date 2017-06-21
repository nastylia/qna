Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      patch :up
      patch :down
      patch :unvote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      patch :mark_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  root to: "questions#index"

  mount ActionCable.server => '/cable'

end
