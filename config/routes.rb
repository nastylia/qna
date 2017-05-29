Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true do
      patch 'mark_best', on: :member
      patch 'vote_up', on: :member
    end
  end

  resources :attachments, only: :destroy

  root to: "questions#index"

end
