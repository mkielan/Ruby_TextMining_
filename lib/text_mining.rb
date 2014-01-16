# encoding: utf-8
require 'text_mining/version'

# ext
require 'ext/array'
require 'ext/string'

# text_mining
require 'text_mining/document'
require 'text_mining/document_comparer'
require 'text_mining/freqs'
require 'text_mining/n_gram'
require 'text_mining/n_grams'
require 'text_mining/n_grams_manager'

# TextMining::Attachments
require 'text_mining/attachments/sheet_source'
require 'text_mining/attachments/mongo_source'
require 'text_mining/attachments/sheet_destination'
require 'text_mining/attachments/file_destination'

# Gui
require 'text_mining/gui/main'
require 'text_mining/gui/document_view'
require 'text_mining/gui/models/document_model'
require 'text_mining/gui/models/document_list_model'

# Helpers
require 'text_mining/helpers/chart_display'
require 'text_mining/helpers/sheet_to_mongo_collection'
require 'text_mining/helpers/cosinus_distance'

module TextMining

  class TextMining
    attr_reader :n_gram_manager

    def initialize source
      @source = source

      @documents = []
      @n_gram_manager = NGramManager.new
      @comparer = DocumentComparer.new @n_gram_manager

      prepare_model
    end

    def search text
      top_similar_to Document.new(text), 1
    end

    def compare document1, document2
      if document1.is_a? Document and document2.is_a? Document
        return @comparer.cos_compare document1, document2
      else
        raise ArgumentError, 'Input objects are not Document'
      end
    end

    def top_similar_to document, top = 5
      document = Document.new(document) if document.is_a? String
      raise ArgumentError, 'document is not Document or String' if !document.is_a? Document
      tops = []

      @documents.each { |d|
        sim = compare document, d

        if sim >= tops.min and sim != 1
          tops << sim

          tops.delete tops.min if tops.length > top
        end
      }

      tops
    end

    def group

    end

    protected
    #
    # Preparing n-grams from learn documents.
    #
    def prepare_model
      while doc = @source.next
        document = Document.new(doc)

        @n_gram_manager.add document
        @documents << document
      end
    end
  end
end
