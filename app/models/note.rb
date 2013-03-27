class Note
    include ActiveFedora::RdfObject
    rdf_type DAMS.Note
    map_predicates do |map|
      map.value(:in=> RDF)
      map.displayLabel(:in=>DAMS)
      map.type(:in=>DAMS)
    end
    def external?
      rdf_subject.to_s.include? Rails.configuration.id_namespace
    end
    def load
      uri = rdf_subject.to_s
      if uri.start_with?(Rails.configuration.id_namespace)
        md = /\/(\w*)$/.match(uri)
        DamsNote.find(md[1])
      end
    end
end