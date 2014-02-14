class DamsRightsHolderInternal
    include ActiveFedora::RdfObject
    include ActiveFedora::Rdf::DefaultNodes
    include Dams::DamsHelper
    map_predicates do |map|
       map.name(:in => MADS, :to => 'authoritativeLabel')   
    end

  rdf_subject { |ds|
    if ds.pid.nil?
      RDF::URI.new
    else
      RDF::URI.new(Rails.configuration.id_namespace + ds.pid)
    end
  }


	def pid
	   rdf_subject.to_s.gsub(/.*\//,'')
	end
      
end
