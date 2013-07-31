# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsTopic do
  subject do
    MadsTopic.new pid: 'zzXXXXXXX1'
  end
  it "should create a xml" do
    exturi = RDF::Resource.new "http://id.loc.gov/authorities/subjects/sh85124118"
    scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd9386739x"
    params = {
      topic: {
        label: "Socialism", externalAuthority: exturi,
        elementList_attributes: [
          topicElement_attributes: [{ elementValue: "Socialism" }]
        ],
        scheme_attributes: [
          id: scheme, code: "lcsh", name: "Library of Congress Subject Headings"
        ]
      }
    }
    subject.damsMetadata.attributes = params[:topic]

    xml =<<END
<rdf:RDF
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
 <mads:Topic rdf:about="#{Rails.configuration.id_namespace}zzXXXXXXX1">
    <mads:authoritativeLabel>Socialism</mads:authoritativeLabel>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/subjects/sh85124118"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="#{Rails.configuration.id_namespace}bd9386739x">
        <rdfs:label>Library of Congress Subject Headings</rdfs:label>
        <mads:code>lcsh</mads:code>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>
    <mads:elementList rdf:parseType="Collection">
      <mads:TopicElement>
        <mads:elementValue>Socialism</mads:elementValue>
      </mads:TopicElement>
    </mads:elementList>
  </mads:Topic>
</rdf:RDF>
END
    subject.damsMetadata.content.should be_equivalent_to xml
  end
end
