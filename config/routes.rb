Dradis::Plugins::PdfExport::Engine.routes.draw do
  resources :projects, only: [] do
    resource :report, only: [:create]
  end
end
