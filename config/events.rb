WebsocketRails::EventMap.describe do
  subscribe :syncer, to: SyncController, with_method: :approve
end
