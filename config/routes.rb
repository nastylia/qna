Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    resources :votes, only: [:up, :down, :unvote] do
      patch :up, on: :collection
      patch :down, on: :collection
      patch :unvote, on: :collection
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      patch :mark_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  root to: "questions#index"

end
