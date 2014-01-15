# encoding: utf-8
require 'text_mining/version'

require 'text_mining/array'
require 'text_mining/string'
require 'text_mining/document'
require 'text_mining/document_comparer'
require 'text_mining/freqs'
require 'text_mining/n_gram'
require 'text_mining/n_grams'
require 'text_mining/n_grams_manager'
require 'text_mining/sequence'

# Attachments
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

module TextMining

  class TextMining
    attr_reader :n_gram_manager

    def initialize source
      @source = source

      @n_gram_manager = NGramManager.new
      @comparer = DocumentComparer.new @n_gram_manager

      prepare_model
    end


    def search text

    end

    def compare document1, document2

    end

    def top_similar_to document, top = 5

    end

    def group

    end

    protected
    #
    # Preparing n-grams from learn documents.
    #
    def prepare_model
      while doc = @source.next
        @n_gram_manager.add Document.new(doc)
      end
    end
  end
end
