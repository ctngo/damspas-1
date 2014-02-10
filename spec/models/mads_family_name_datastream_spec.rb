# -*- encoding: utf-8 -*-
require 'spec_helper'

describe MadsFamilyNameDatastream do
  describe "nested attributes" do
    it "should create rdf/xml" do
      exturi = RDF::Resource.new "http://id.loc.gov/authorities/names/n90694888"
      scheme = RDF::Resource.new "http://library.ucsd.edu/ark:/20775/bd0683587d"
      params = {
        familyName: {
          name: "Burns, Jack O., Dr., 1977-", externalAuthority: exturi,         
          familyNameElement_attributes: [{ elementValue: "Burns" }],
          givenNameElement_attributes: [{ elementValue: "Jack O." }],
          termsOfAddressNameElement_attributes: [{ elementValue: "Dr." }],
          dateNameElement_attributes: [{ elementValue: "1977-" }],
          fullNameElement_attributes: [{ elementValue: "FullNameValue" }],
          nameElement_attributes: [{ elementValue: "NameElementValue" }],
          scheme_attributes: [
            id: scheme, code: "naf", name: "Library of Congress Name Authority File"
          ]
        }
      }
      subject = MadsFamilyNameDatastream.new(double("inner object", pid:"bd93182924", new_record?: true))
      subject.attributes = params[:familyName]

      xml =<<END
<rdf:RDF xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
  <mads:FamilyName rdf:about="http://library.ucsd.edu/ark:/20775/bd93182924">
    <mads:authoritativeLabel>Burns, Jack O., Dr., 1977-</mads:authoritativeLabel>
    <mads:elementList rdf:parseType="Collection">  
      <mads:FamilyNameElement>
        <mads:elementValue>Burns</mads:elementValue>
      </mads:FamilyNameElement>
      <mads:GivenNameElement>
        <mads:elementValue>Jack O.</mads:elementValue>
      </mads:GivenNameElement>
      <mads:TermsOfAddressNameElement>
         <mads:elementValue>Dr.</mads:elementValue>
      </mads:TermsOfAddressNameElement>
      <mads:DateNameElement>
        <mads:elementValue>1977-</mads:elementValue>
      </mads:DateNameElement>
      <mads:FullNameElement>
        <mads:elementValue>FullNameValue</mads:elementValue>
      </mads:FullNameElement>
      <mads:NameElement>
        <mads:elementValue>NameElementValue</mads:elementValue>
      </mads:NameElement>            
    </mads:elementList>
    <mads:hasExactExternalAuthority rdf:resource="http://id.loc.gov/authorities/names/n90694888"/>
    <mads:isMemberOfMADSScheme>
      <mads:MADSScheme rdf:about="http://library.ucsd.edu/ark:/20775/bd0683587d">
        <mads:code>naf</mads:code>
        <rdfs:label>Library of Congress Name Authority File</rdfs:label>
      </mads:MADSScheme>
    </mads:isMemberOfMADSScheme>
  </mads:FamilyName>
</rdf:RDF>
END
      subject.content.should be_equivalent_to xml
    end

    describe "a new instance" do
      subject { MadsFamilyNameDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new_record? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Maria"
        subject.name.should == ["Maria"]
      end   
 
      it "element should update name" do
        subject.fullNameElement_attributes = {'0' => { elementValue: "Test" }}
        subject.authLabel.should == "Test"
      end
      it "element should not update name if name is already set" do
        subject.name = "Original"
        subject.fullNameElement_attributes = {'0' => { elementValue: "Test" }}
        subject.name.should == ["Original"]
        subject.authLabel.should == "Original"
      end
      it "element should not update name if element is blank" do
        subject.name = "Original"
        subject.fullNameElement_attributes = [{ elementValue: nil }]
        subject.authLabel.should == "Original"
      end
    end

    describe "an instance with content" do
      subject do
        subject = MadsFamilyNameDatastream.new(double('inner object', :pid=>'bd1775562z', :new_record? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/madsFamilyName.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Calder (Family : 1757-1959 : N.C.)"]
      end
 
      it "should have an scheme" do
        subject.scheme.first.pid.should == "bd0683587d"
      end
           
      it "should have fields" do
        list = subject.elementList
        "#{list[0].class.name}".should == "Dams::MadsNameElements::MadsFamilyNameElement"
        list[0].elementValue.should == "Calder (Family :"  
        "#{list[1].class.name}".should == "Dams::MadsNameElements::MadsDateNameElement"
        list[1].elementValue.should == "1757-1959 :"
        "#{list[2].class.name}".should == "Dams::MadsNameElements::MadsTermsOfAddressNameElement"
        list[2].elementValue.should == "N.C.)"                           
        list.size.should == 3  
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["family_name_element_tesim"].should == ["Calder (Family :"]
        solr_doc["date_name_element_tesim"].should == ["1757-1959 :"]
        solr_doc["terms_of_address_name_element_tesim"].should == ["N.C.)"]     
      end    
    end
  end
end
