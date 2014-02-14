class DamsUnitInternal
  include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
    include Dams::DamsHelper
    rdf_type DAMS.Unit
  rdf_subject { |ds|
    if ds.pid.nil?
      RDF::URI.new
    else
      RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
    end
  }

  map_predicates do |map|
    map.name(:in => DAMS, :to => 'unitName')
    map.description(:in => DAMS, :to => 'unitDescription')
    map.uri(:in => DAMS, :to => 'unitURI')
    map.code(:in => DAMS, :to => 'code')
    map.group(:in => DAMS, :to => 'unitGroup')
 end

  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def pid
      rdf_subject.to_s.gsub(/.*\//,'')
  end
  def persisted?
    rdf_subject.kind_of? RDF::URI
  end
  def id
    rdf_subject if rdf_subject.kind_of? RDF::URI
  end  
end
