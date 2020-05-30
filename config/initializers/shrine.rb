require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/url"

Shrine.storages = {
  # cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
  cache: Shrine::Storage::Url.new,
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),       # permanent
}

Shrine.plugin :activerecord
# Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
# Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :derivatives
