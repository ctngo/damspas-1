class MadsTitle
  include ActiveFedora::RdfObject
  include Dams::DamsHelper
  include Dams::MadsTitle
  def persisted?
    rdf_subject.kind_of? RDF::URI
  end  
end
