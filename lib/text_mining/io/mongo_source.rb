require 'mongo'

include Mongo

module TextMining::IO
  class MongoSource

    def initialize collection, body_attr
      if !collection.is_a? Collection
        raise ArgumentError, 'collection is not Mongo::Collection Class Object'
      end

      @collection = collection
      @each = @collection.find
      @body_attr = body_attr
    end

    def next
      @doc = @each.next
      @doc[@body_attr.to_s]
    end

    def current
      @doc
    end

    def count
      @collection.count
    end
  end
end
