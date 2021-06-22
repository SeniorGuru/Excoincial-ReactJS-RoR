# frozen_string_literal: true

module Entities
  class Article < Grape::Entity
    expose :id, documentation: { type: 'String' }
    expose :title, documentation: { type: 'String' }
    expose :sub_title, documentation: { type: 'String' }
    expose :content, documentation: { type: 'String' }
    expose :published, documentation: { type: 'String' }
    expose :published_at, documentation: { type: 'Date' }
    expose :hero_image, documentation: { type: 'String' }
    expose :created_at, documentation: { type: 'Date' }
    expose :updated_at, documentation: { type: 'Date' }
    expose :slug, documentation: { type: 'String' }
    expose :gplus_url, documentation: { type: 'String' }
    expose :featured, documentation: { type: 'String' }
    expose :document, documentation: { type: 'String' }
    expose :short_hero_image, documentation: { type: 'String' }
    expose :teaser, documentation: { type: 'String' }
    expose :tag_list, documentation: { type: 'String' }
  end
end
