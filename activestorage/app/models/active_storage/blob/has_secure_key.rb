# frozen_string_literal: true
require 'active_storage/key_generator'

module ActiveStorage::Blob::HasSecureKey
  extend ActiveSupport::Concern

  included do
    has_secure_token :key
  end

  # Returns the key pointing to the file on the service that's associated with this blob. The key is in the
  # standard secure-token format from Rails. So it'll look like: XTAPjJCJiuDrLk3TmwyJGpUo. This key is not intended
  # to be revealed directly to the user. Always refer to blobs using the signed_id or a verified form of the key.
  def key
    # We can't wait until the record is first saved to have a key for it
    self[:key] ||= ActiveStorage::KeyGenerator.new(self).generate
  end
end
