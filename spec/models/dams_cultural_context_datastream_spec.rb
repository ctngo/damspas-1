# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DamsCulturalContextDatastream do

  describe "a complex data model" do

    describe "a new instance" do
      subject { DamsCulturalContextDatastream.new(double('inner object', :pid=>'bbXXXXXXXXX23', :new? =>true), 'damsMetadata') }
      it "should have a subject" do
        subject.rdf_subject.to_s.should == "#{Rails.configuration.id_namespace}bbXXXXXXXXX23"
      end

      it "should have a name" do
        subject.name = "Dutch"
        subject.name.should == ["Dutch"]
      end   
      it "should have scheme" do
        subject.scheme = "bd45402766"
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd45402766"
      end          
    end

    describe "an instance with content" do
      subject do
        subject = DamsCulturalContextDatastream.new(double('inner object', :pid=>'bd0410365x', :new? =>true), 'damsMetadata')
        subject.content = File.new('spec/fixtures/damsCulturalContext.rdf.xml').read
        subject
      end
      
      
      it "should have name" do
        subject.name.should == ["Dutch"]
      end
 
      it "should have an scheme" do
        subject.scheme.to_s.should == "#{Rails.configuration.id_namespace}bd45402766"
      end

      it "should have a valueURI" do
        subject.externalAuthority.to_s.should == "http://id.loc.gov/XXX01"
      end

      it "should have fields" do
        list = subject.elementList.first
        list[0].should be_kind_of DamsCulturalContextDatastream::List::CulturalContextElement
        list[0].elementValue.should == ["Dutch"]       
        list.size.should == 1       
      end  
      
      it "should have a fields from solr doc" do
        solr_doc = subject.to_solr
        solr_doc["culturalContext_element_tesim"].should == ["Dutch"]
        solr_doc["name_tesim"].should == ["Dutch"]
        solr_doc["scheme_tesim"].should == ["#{Rails.configuration.id_namespace}bd45402766"]
        solr_doc["externalAuthority_tesim"].should == ["http://id.loc.gov/XXX01"]
      end    
    end
  end
end
