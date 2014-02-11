class DamsCartographicsInternal
  include ActiveFedora::RdfObject
#  include ActiveFedora::Rdf::DefaultNodes
  rdf_type DAMS.Cartographics
  map_predicates do |map|
    map.point(:in=>DAMS)
    map.line(:in=>DAMS)
    map.polygon(:in=>DAMS)
    map.projection(:in=>DAMS)
    map.referenceSystem(:in=>DAMS)
    map.scale(:in=>DAMS)
  end

  rdf_subject { |ds|
    if ds.pid.nil?
      RDF::URI.new
    else
      RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
    end
  }


  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.Cartographics]) if new?
    super
  end

  def persisted?
    rdf_subject.kind_of? RDF::URI
  end
  def pid
    rdf_subject.to_s.gsub(/.*\//,'')
  end
end
