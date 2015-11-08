WebsocketRails::EventMap.describe do
  namespace :syncer do
    subscribe :progress, to: SyncController, with_method: :approve
    subscribe :yearly, to: SyncController, with_method: :approve
    subscribe :repos, to: SyncController, with_method: :approve
  end
end
