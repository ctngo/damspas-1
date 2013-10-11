
function getName(type,q,location)
{
  $.get(baseURL+"/get_name/get_name?formType="+type+"&q="+q,function(data,status){
    $(location).html(data);
  });	 
}

function getSubjects(type,q,location,fieldName,label)
{
  $.get(baseURL+"/get_subject/get_subject?label="+label+"&fieldName="+fieldName+"&formType="+type+"&q="+q,function(data,status){
    $(location).html(data);
  });	

  if( label == 'Subject') {
	  $('#simpleSubjects').show();
	  
	  var subjectsArray =new Array("BuiltWorkPlace","CulturalContext","Function","GenreForm","Geographic","Iconography","Occupation","ScientificName","StylePeriod","Technique","Temporal","Topic");
	  for (var i in subjectsArray) {
	  	if(subjectsArray[i] == q) {
		  $('#'+q).show();
		}else {
		  $('#'+subjectsArray[i]).hide();
		}
	  }
   }

  if( label == 'Name' && fieldName == 'nameURI') {
	  toggleRelationshipNames(q,"","names");
   }   
}

function displayRelationshipName(value)
{
  toggleRelationshipNames(value,"relationship","relationshipNames");
}

function toggleRelationshipNames(value, label, section)
{
  $('#'+section).show();
  
  var namesArray =new Array("Name","PersonalName","CorporateName","ConferenceName","FamilyName");
  for (var i in namesArray) {
  	if(namesArray[i] == value) {
	  $('#'+label+value).show();
	}else {
	  $('#'+label+namesArray[i]).hide();
	}
  }
}

//parsing parameters as "#dams_object_", #dams_provenance_collection_", "#dams_assembled_collection_","#dams_provenance_collection_part",etc,
function processForm_generic(objType) {
    var attributesArray =new Array("assembledCollection","provenanceCollection","provenanceCollectionPart","complexSubject","statute","license","copyright","language","unit","rightsHolderPersonal");
    var fieldId = "";
    for (var j in attributesArray) {
      fieldId = objType+attributesArray[j]+"_attributes_0_id";
      if($(fieldId).val().length < 1) {
        $(fieldId).remove();
    }     
    }   
  
    var subjectsArray =new Array("BuiltWorkPlace","CulturalContext","Function","GenreForm","Geographic","Iconography","Occupation","ScientificName","StylePeriod","Technique","Temporal","Topic","Name","PersonalName","CorporateName","ConferenceName","FamilyName");
    fieldId = "";
    for (var i in subjectsArray) {
      fieldId = objType+subjectsArray[i].charAt(0).toLowerCase()+subjectsArray[i].slice(1)+"_attributes_0_name";
      if($(fieldId).val().length < 1) {
        $("#"+subjectsArray[i]).remove();
    }     
    }

    var relNamesArray =new Array("Name","PersonalName","CorporateName","ConferenceName","FamilyName");
    fieldId = "";
    for (var i in relNamesArray) {
      fieldId = objType+"relationship_attributes_0_"+relNamesArray[i].charAt(0).toLowerCase()+relNamesArray[i].slice(1)+"_attributes_0_id";
      if($(fieldId).val().length < 1) {
        $("#relationship"+relNamesArray[i]).remove();
    }     
    }
                                   
    if($(objType+"date_attributes_0_value").val().length < 1)
    {
      $("#dateSection").remove();
    }
    
    if($(objType+"note_attributes_0_value").val().length < 1)
    {
      $("#noteSection").remove();
    }

    if($(objType+"scopeContentNote_attributes_0_value").val().length < 1)
    {
      $("#scopeNoteSection").remove();
    }
    
    if($(objType+"custodialResponsibilityNote_attributes_0_value").val().length < 1)
    {
      $("#custodialNoteSection").remove();
    }
    
    if($(objType+"preferredCitationNote_attributes_0_value").val().length < 1)
    {
      $("#preferredNoteSection").remove();
    }    

    if($(objType+"relatedResource_attributes_0_description").val().length < 1 && $(objType+"relatedResource_attributes_0_type").val().length < 1 )
    {
      $("#relatedResourceSection").remove();
    }
    
    if($(objType+"cartographics_attributes_0_point").val().length < 1 && $(objType+"cartographics_attributes_0_line").val().length < 1)
    {
      $("#cartographicsSection").remove();
    }

    if($(objType+"relationship_attributes_0_role_attributes_0_id").val().length < 1)
    {
      $(objType+"relationship_attributes_0_role_attributes_0_id").remove();
    }
    
    if($(objType+"language_attributes_0_name").val().length < 1)
    {
      $("#newLanguage").remove();
    }                  
    return true; 
}



function processForm() {
    var attributesArray =new Array("assembledCollection","provenanceCollection","provenanceCollectionPart","complexSubject","statute","license","copyright","language","unit","rightsHolderPersonal");
    var fieldId = "";
    for (var j in attributesArray) {
      fieldId = "#dams_object_"+attributesArray[j]+"_attributes_0_id";
  	  if($(fieldId).val().length < 1) {
	      $(fieldId).remove();
	  } 	  
    }  	
 	
    var subjectsArray =new Array("BuiltWorkPlace","CulturalContext","Function","GenreForm","Geographic","Iconography","Occupation","ScientificName","StylePeriod","Technique","Temporal","Topic","Name","PersonalName","CorporateName","ConferenceName","FamilyName");
    fieldId = "";
    for (var i in subjectsArray) {
      fieldId = "#dams_object_"+subjectsArray[i].charAt(0).toLowerCase()+subjectsArray[i].slice(1)+"_attributes_0_name";
  	  if($(fieldId).val().length < 1) {
	      $("#"+subjectsArray[i]).remove();
	  } 	  
    }

    var relNamesArray =new Array("Name","PersonalName","CorporateName","ConferenceName","FamilyName");
    fieldId = "";
    for (var i in relNamesArray) {
      fieldId = "#dams_object_relationship_attributes_0_"+relNamesArray[i].charAt(0).toLowerCase()+relNamesArray[i].slice(1)+"_attributes_0_id";
  	  if($(fieldId).val().length < 1) {
	      $("#relationship"+relNamesArray[i]).remove();
	  } 	  
    }
                                   
    if($("#dams_object_date_attributes_0_value").val().length < 1)
    {
      $("#dateSection").remove();
    }
    
    if($("#dams_object_note_attributes_0_value").val().length < 1)
    {
      $("#noteSection").remove();
    }

    if($("#dams_object_scopeContentNote_attributes_0_value").val().length < 1)
    {
      $("#scopeNoteSection").remove();
    }
    
    if($("#dams_object_custodialResponsibilityNote_attributes_0_value").val().length < 1)
    {
      $("#custodialNoteSection").remove();
    }
    
    if($("#dams_object_preferredCitationNote_attributes_0_value").val().length < 1)
    {
      $("#preferredNoteSection").remove();
    }    

    if($("#dams_object_relatedResource_attributes_0_description").val().length < 1 && $("#dams_object_relatedResource_attributes_0_type").val().length < 1 )
    {
      $("#relatedResourceSection").remove();
    }
    
    if($("#dams_object_cartographics_attributes_0_point").val().length < 1 && $("#dams_object_cartographics_attributes_0_line").val().length < 1)
    {
      $("#cartographicsSection").remove();
    }

    if($("#dams_object_relationship_attributes_0_role_attributes_0_id").val().length < 1)
    {
      $("#dams_object_relationship_attributes_0_role_attributes_0_id").remove();
    }
    
    if($("#dams_object_language_attributes_0_name").val().length < 1)
    {
      $("#newLanguage").remove();
    }                  
    return true; 
}

function setLanguageId_generic(objType) {
  $.get(baseURL+"/get_ark/get_ark",function(data,status){
    var ark = "http://library.ucsd.edu/ark:/20775/"+data;
    $(objType+"language_attributes_0_id").val(ark.trim());
    $("#newLanguageLink").remove();
  });
}

function setLanguageId() {
  $.get(baseURL+"/get_ark/get_ark",function(data,status){
  	var ark = "http://library.ucsd.edu/ark:/20775/"+data;
    $("#dams_object_language_attributes_0_id").val(ark.trim());
    $("#newLanguageLink").remove();
  });
}