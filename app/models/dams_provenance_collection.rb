class DamsProvenanceCollection < ActiveFedora::Base
  has_metadata 'damsMetadata', :type => DamsProvenanceCollectionDatastream 
  delegate_to "damsMetadata", [:scopeContentNoteType, :scopeContentNoteDisplayLabel, :scopeContentNoteValue, :noteValue, :noteType, :noteDisplayLabel, :relationshipName, :languageValue, :title, :titleType, :titleValue, :subtitle, :typeOfResource, :date, :dateValue, :beginDate, :endDate, :subject, :topic, :component, :file, :relatedResource, :language, :unit, :note, :sourceCapture, :subjectValue, :subjectURI, :unitURI, :subjectType, :subjectTypeValue ]

 def part
    damsMetadata.load_part
  end

 
  
end
