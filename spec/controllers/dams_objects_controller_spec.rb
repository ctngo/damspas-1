require 'spec_helper'
require 'net/http'
require 'json'

describe DamsObjectsController do
  describe "A login user" do
	  before do
	  	sign_in User.create! ({:provider => 'developer'})
	  end
	  describe "View" do
	    before do
	      @obj = DamsObject.create(titleValue: "Test Title", beginDate: "2013", copyrightURI: "bb05050505")
	      #puts @obj.id
	      # reindex the record
	      solr_index @obj.id
	    end
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful
	      @newobj = assigns[:dams_object]
          @newobj.titleValue.should == @obj.titleValue
          @newobj.beginDate.should == @obj.beginDate
	    end    
	  end
	  
	  describe "New" do
	    it "should be successful" do 
	      get :new
	      response.should be_successful 
	      assigns[:dams_object].should be_kind_of DamsObject
	    end
	  end
	  
	  describe "Edit" do
	    it "should be successful" do
	      get :edit, id: @obj.id
	      response.should be_successful 
	      @newobj = assigns[:dams_object]
          @newobj.titleValue.should == @obj.titleValue
          @newobj.beginDate.should == @obj.beginDate
	    end
	  end
	  
	  describe "Create" do
	    
	    it "should be successful" do
	      expect { 
	       #post :create, :dams_object => {titleValue: ["Test Title"], "subjectType"=>["Topic","BuiltWorkPlace","Temporal"], "subjectTypeValue"=>["testTopicValue","testWorkplaceValue1","testTemporal"]}	      
	       #post :create, :dams_object => {titleValue: ["Test Title"], beginDate: ["2013"], typeOfResource: ["text"], subjectValue: ["subjectValue1", "subjectValue2"]}
	       #post :create, :dams_object => {titleValue: ["Test Title"], relationshipRoleURI: ["bb0376727p"], relationshipNameURI: ["xx00010235"], relationshipNameType: ["CorporateName"]}
	       #post :create, :dams_object => {titleValue: ["Test Title"], relationshipRoleURI: [""], relationshipNameType: [""]}
	       #post :create, :dams_object => {titleValue: ["Test Title"], relationshipRoleURI: ["xx00000544"], relationshipNameValue: ["V6"], relationshipNameType: ["PersonalName"]}
		   post :create, :dams_object => {"title_attributes"=>{"0"=>{mainTitleElement_attributes: [{ elementValue: "Sample Complex Object Record #1" }]}},"copyright_attributes"=>[{"id"=>"http://library.ucsd.edu/ark:/20775/bb05050505"}]}
		   #puts assigns[:dams_object].pid
        }.to change { DamsObject.count }.by(1)
	      response.should redirect_to assigns[:dams_object]
	      assigns[:dams_object].should be_kind_of DamsObject
	    end
	  end
	  
	  describe "Update" do
	    it "should be successful" do
	      
	      put :update, :id => @obj.id, :dams_object => {titleValue:"Updated Title", beginDate: ["2013"]}
	      response.should redirect_to assigns[:dams_object]
          @newobj = assigns[:dams_object]
	      @newobj.titleValue.should == "Updated Title"
	      @newobj.beginDate.should == ["2013"]
	      flash[:notice].should == "Successfully updated object"
	    end
    end
  end
end
