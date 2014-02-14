require 'spec_helper'

describe DamsProvenanceCollectionPartsController do
  describe "A login user" do
	  before do
	  	sign_in User.create! ({:provider => 'developer'})
    	#DamsProvenanceCollectionPart.find_each{|z| z.delete}
	  end
	  describe "Show" do
	    before do
	      @obj = DamsProvenanceCollectionPart.create(titleValue: "Test Provenance Collection Part Title", beginDate: "2012", endDate: "2013", visibility: "public", resource_type: "text")
	    end
	    it "should be successful" do 
	      get :show, id: @obj.id
	      response.should be_successful 
	      @newobj = assigns[:dams_provenance_collection_part]
          @newobj.titleValue.should == @obj.titleValue
          @newobj.beginDate.should == @obj.beginDate
          @newobj.endDate.should == @obj.endDate
          @newobj.visibility.should == @obj.visibility
          @newobj.resource_type.should == @obj.resource_type
	    end
	  end
	  
	  describe "New" do
	    it "should be successful" do 
	      get :new
	      response.should be_successful 
	      assigns[:dams_provenance_collection_part].should be_kind_of DamsProvenanceCollectionPart
	    end
	  end
	  
	  describe "Edit" do
	    before do
	      @obj = DamsProvenanceCollectionPart.create(titleValue: "Test Provenance Collection Title", beginDate: "2012", endDate: "2013", visibility: "public", resource_type: "text")
          solr_index @obj.pid
	    end    
	    it "should be successful" do 
	      get :edit, id: @obj.id
	      response.should be_successful 
	      @newobj = assigns[:dams_provenance_collection_part]
          @newobj.titleValue.should == @obj.titleValue
          @newobj.beginDate.should == @obj.beginDate
          @newobj.endDate.should == @obj.endDate
          @newobj.visibility.should == @obj.visibility
          @newobj.resource_type.should == @obj.resource_type
	    end
	  end
	  
	  describe "Create" do
	    it "should be successful" do
	      expect { 
	        post :create, :dams_provenance_collection_part => {titleValue: ["Test Title"], beginDate: ["2013"]}
        }.to change { DamsProvenanceCollectionPart.count }.by(1)
	      response.should redirect_to assigns[:dams_provenance_collection_part]
	      assigns[:dams_provenance_collection_part].should be_kind_of DamsProvenanceCollectionPart
	    end
	  end
	  
	  describe "Update" do
	    before do
 	      @obj = DamsProvenanceCollectionPart.create(titleValue: "Test Provenance Collection Title", beginDate: "2012", endDate: "2013")
          solr_index @obj.pid
 	    end
	    it "should be successful" do
	      put :update, :id => @obj.id, :dams_provenance_collection_part => {titleValue: ["Test Title2"], beginDate: ["2013"]}
	      response.should redirect_to assigns[:dams_provenance_collection_part]
	      @obj.reload.titleValue.should == "Test Title2"
	      flash[:notice].should == "Successfully updated provenance_collection_part"
	    end
    end
  end
end

