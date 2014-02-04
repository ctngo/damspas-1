require 'spec_helper'

describe DamsProvenanceCollectionsController do
  describe "A login user" do
      before do
          sign_in User.create! ({:provider => 'developer'})
        #DamsProvenanceCollection.find_each{|z| z.delete}
      end
      describe "Show" do
        before do
          @obj = DamsProvenanceCollection.create(titleValue: "Test Provenance Collection Title 1", beginDate: "2012-01-01", endDate: "2013-01-01", visibility: "public", resource_type: "text")
          # reindex the record
          solr_index @obj.id
        end
        it "should be successful" do 
          get :show, id: @obj.id
          response.should be_successful 
          @newobj = assigns[:dams_provenance_collection]
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
          assigns[:dams_provenance_collection].should be_kind_of DamsProvenanceCollection
        end
      end
      
      describe "Edit" do
        before do
          @obj = DamsProvenanceCollection.create(titleValue: "Test Provenance Collection Title 2", beginDate: "2012-02-02", endDate: "2013-02-02", visibility: "public", resource_type: "text")
          # reindex the record
          solr_index @obj.id
        end    
        it "should be successful" do 
          get :edit, id: @obj.id
          response.should be_successful 
          @newobj = assigns[:dams_provenance_collection]
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
            post :create, :dams_provenance_collection => {titleValue: "Test Provenance Collection Title 3", beginDate: "2013-03-03"}
        }.to change { DamsProvenanceCollection.count }.by(1)
          response.should redirect_to assigns[:dams_provenance_collection]
          assigns[:dams_provenance_collection].should be_kind_of DamsProvenanceCollection
        end
      end
      
      describe "Update" do
        before do
           @obj = DamsProvenanceCollection.create(titleValue: "Test Provenance Collection Title 4", beginDate: "2012-04-04", endDate: "2013-04-04")
           # reindex the record
           solr_index @obj.id
         end
        it "should be successful" do
          params = { "titleValue"=>["Test Title 5"], "languageURI"=>["bd0410344f"], "scopeContentNote_attributes"=>{"0"=>{"value"=>"test"}}}
          put :update, :id => @obj.id, :dams_provenance_collection => params
          response.should redirect_to assigns[:dams_provenance_collection]
          @obj.reload.titleValue.should == "Test Title 5"
          flash[:notice].should == "Successfully updated provenance_collection"
        end
    end
  end
end

