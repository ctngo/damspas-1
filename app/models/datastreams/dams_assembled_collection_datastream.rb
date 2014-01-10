class DamsAssembledCollectionDatastream < DamsResourceDatastream
  include Dams::DamsAssembledCollection
  include Dams::ModelHelper
	      
  def to_solr (solr_doc = {})
    facetable = Solrizer::Descriptor.new(:string, :indexed, :multivalued)
    Solrizer.insert_field(solr_doc, 'type', 'Collection')
    Solrizer.insert_field(solr_doc, 'type', 'Collection',facetable)
    Solrizer.insert_field(solr_doc, 'type', 'AssembledCollection')
    Solrizer.insert_field(solr_doc, 'resource_type', format_name(resource_type))
    Solrizer.insert_field(solr_doc, 'object_type', format_name(resource_type),facetable)
    Solrizer.insert_field(solr_doc, 'visibility', visibility)
    
    insertCollectionFields solr_doc, 'provenanceCollection', provenanceCollection_node, DamsProvenanceCollection
    insertCollectionFields solr_doc, 'part', part_node, DamsProvenanceCollectionPart
	insertUnitFields solr_doc, unit
    super
  end  
end
