class DamsDAMSEventDatastream < ActiveFedora::RdfxmlRDFDatastream
  map_predicates do |map|
    map.type(:in => DAMS, :to => 'type')
    map.eventDate(:in => DAMS, :to => 'eventDate')
    map.outcome(:in => DAMS, :to => 'outcome')
    map.relationship(:in => DAMS, :class_name => 'Relationship')
  end

  class Relationship
    include ActiveFedora::RdfObject
    rdf_type DAMS.Relationship
    map_predicates do |map|
      map.name(:in=> DAMS)
      map.personalName(:in=> DAMS)
      map.corporateName(:in=> DAMS)
      map.role(:in=> DAMS)
    end

    def load
      if name.first.to_s.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(name.first.to_s)
        MadsPersonalName.find(md[1])
      elsif personalName.first.to_s.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(personalName.first.to_s)
        MadsPersonalName.find(md[1])
      elsif corporateName.first.to_s.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(corporateName.first.to_s)
        MadsCorporateName.find(md[1])
      end
    end

    def loadRole
      uri = role.first.to_s
      if uri.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(uri)
        DamsRole.find(md[1])
      end
    end   
  end
  
  rdf_subject { |ds| RDF::URI.new(Rails.configuration.id_namespace + ds.pid)}

  def serialize
    graph.insert([rdf_subject, RDF.type, DAMS.DAMSEvent]) if new?
    super
  end

  def to_solr (solr_doc = {})
	Solrizer.insert_field(solr_doc, 'type', type)
	Solrizer.insert_field(solr_doc, 'eventDate', eventDate)
	Solrizer.insert_field(solr_doc, 'outcome', outcome)

    names = []
    relationship.map do |relationship|
      rel = relationship.load
      if (rel != nil)
        #Solrizer.insert_field(solr_doc, 'name', relationship.load.name )
        begin
          names << rel.name.first.to_s
        rescue
          puts "error: #{rel}"
        end
      end
      relRole = relationship.loadRole
      if ( rel != nil )
        Solrizer.insert_field(solr_doc, 'role', relationship.loadRole.value )
        Solrizer.insert_field(solr_doc, 'role_code', relationship.loadRole.code )
        Solrizer.insert_field(solr_doc, 'role_valueURI', relationship.loadRole.valueURI.first.to_s )
      end      
    end
    names.sort.each do |n|
      Solrizer.insert_field(solr_doc, 'name', n )
    end
 # hack to strip "+00:00" from end of dates, because that makes solr barf
    ['system_create_dtsi','system_modified_dtsi'].each { |f|
      if solr_doc[f].kind_of?(Array)
        solr_doc[f][0] = solr_doc[f][0].gsub('+00:00','Z')
      elsif solr_doc[f] != nil
        solr_doc[f] = solr_doc[f].gsub('+00:00','Z')
      end
    }
    return solr_doc
  end

end
