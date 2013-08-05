require 'active_support/concern'

module Dams
  module MadsTopic
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type MADS.Topic
      accepts_nested_attributes_for :topicElement, :scheme
      def serialize
        graph.insert([rdf_subject, RDF.type, MADS.Topic]) if new?
        super
      end
      delegate :topicElement_attributes=, to: :elementList
      alias_method :topicElement, :elementList
      def topicElement_with_update_name= (attributes)
        self.topicElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue
        end
      end
      alias_method :topicElement_without_update_name=, :topicElement_attributes=
      alias_method :topicElement_attributes=, :topicElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'topic', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "topic_element", elementList.first.elementValue.to_s)
        end
        solr_base solr_doc
      end
      class MadsTopicElementList
        include ActiveFedora::RdfList
        map_predicates do |map|
          map.topicElement(:in=> MADS, :to =>"TopicElement", :class_name => "MadsTopicElement")
        end
        accepts_nested_attributes_for :topicElement
      end
      class MadsTopicElement
        include Dams::MadsElement
        rdf_type MADS.TopicElement
      end
    end
  end
end
