require 'active_support/concern'

module Dams
  module DamsBuiltWorkPlace
    extend ActiveSupport::Concern
    include Dams::MadsSimpleType
    included do
      rdf_type DAMS.BuiltWorkPlace
      map_predicates do |map|
        map.elem_list(:in => MADS, :to => 'elementList', :class_name=>'DamsBuiltWorkPlaceElementList')
      end

      def elementList
        elem_list.first || elem_list.build
      end      
      accepts_nested_attributes_for :builtWorkPlaceElement, :scheme
      def serialize
        check_type( graph, rdf_subject, DAMS.BuiltWorkPlace )
        super
      end
      delegate :builtWorkPlaceElement_attributes=, to: :elementList
      alias_method :builtWorkPlaceElement, :elementList
      def builtWorkPlaceElement_with_update_name= (attributes)
        self.builtWorkPlaceElement_without_update_name= attributes
        if elementList && elementList.first && elementList.first.elementValue.present?
          self.name = elementList.first.elementValue.to_s
        end
      end
      alias_method :builtWorkPlaceElement_without_update_name=, :builtWorkPlaceElement_attributes=
      alias_method :builtWorkPlaceElement_attributes=, :builtWorkPlaceElement_with_update_name=
      def to_solr (solr_doc={})
        Solrizer.insert_field(solr_doc, 'built_work_place', name)
        if elementList.first
          Solrizer.insert_field(solr_doc, "built_work_place_element", elementList.first.elementValue.to_s)
        end
	    # hack to make sure something is indexed for rights metadata
	    ['edit_access_group_ssim','read_access_group_ssim','discover_access_group_ssim'].each {|f|
	      solr_doc[f] = 'dams-curator' unless solr_doc[f]
	    }
        solr_base solr_doc
      end
    end
    class DamsBuiltWorkPlaceElementList
      include ActiveFedora::RdfList
      map_predicates do |map|
        map.builtWorkPlaceElement(:in=> DAMS, :to =>"BuiltWorkPlaceElement", :class_name => "DamsBuiltWorkPlaceElement")
      end
      accepts_nested_attributes_for :builtWorkPlaceElement
    end
    class DamsBuiltWorkPlaceElement
      include Dams::MadsElement
      rdf_type DAMS.BuiltWorkPlaceElement
      def persisted?
        rdf_subject.kind_of? RDF::URI
      end
    end
  end
end
