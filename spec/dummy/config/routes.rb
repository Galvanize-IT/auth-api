Rails.application.routes.draw do
  root to: 'application#welcome'
  mount AuthApi::Engine, at: '/'
end
