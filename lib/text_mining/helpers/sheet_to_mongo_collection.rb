require 'mongo'

include Mongo

module TextMining::Helpers
  class SheetToMongoCollection

    def self.do sheet_source, collection, attribute_keys
      raise ArgumentError, 'Sheet_source is not SheetSource object' if !sheet_source.is_a? SheetSource
      raise ArgumentError, 'Collection is not Mongo:Collection' if !collection.is_a? Collection
      raise ArgumentError, 'AttributeKeys is not Array' if !attribute_keys.is_a? Array

      doc_id = collection.count
      while row = sheet_source.next
        puts 'DocumentID: ' + (doc_id + 1).to_s + '/' + sheet_source.count.to_s

        document = Hash.new
        document[:_id] = doc_id
        row.length.times { |col|
          document[attribute_keys[col]] = row[col] if !row[col].is_a? NilClass
        }

        collection.insert document
        doc_id += 1
      end
    end
  end
end