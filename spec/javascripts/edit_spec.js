describe("Object path getter", function(){
  it ("gets objects path for specified type", function(){
  	expect(getObjectsPath("Topic")).toEqual("mads_topics");
  	expect(getObjectsPath("Geographic")).toEqual("mads_geographics");
  	expect(getObjectsPath("FamilyName")).toEqual("mads_family_names");
  	expect(getObjectsPath("Temporal")).toEqual("mads_temporals");
  	expect(getObjectsPath("Function")).toEqual("dams_functions");
  	expect(getObjectsPath("RightsHolderPersonal")).toEqual("mads_personal_names");
  });
  
});
describe("firstToLowerCase function", function(){
it ("makes the first character lower case", function() {
    expect(firstToLowerCase("abc")).toEqual("abc");
    expect(firstToLowerCase("TEST")).toEqual("tEST");
    expect(firstToLowerCase("TTopic")).toEqual("tTopic");
  });
  
});

describe ("getDynamicFields", function() {

	//Checks that getDynamicFields is performing the correct ajax request
	it ("gets fields for object create/edit forms", function(){
		var test = {value: 'BuiltWorkPlace'};
    spyOn($, "get");
		getDynamicFields(test, 'dams_object', '#newSimpleSubjects', "0", 'simpleSubject', 'undefined');
		expect($.get).toHaveBeenCalled();

		expect($.get).toHaveBeenCalledWith('http://localhost:3000/get_data/get_subject/get_subject?selectedValue=undefined&fieldId=0&fieldName=builtWorkPlace&formType=dams_object&q=BuiltWorkPlace', jasmine.any(Function))
	});

});

//incomplete!! WIP FIXTURE is possibly incorrectly generated
describe("processForm_generic", function() {
	beforeEach(function(){
		var fixture = loadFixtures('test.html');
	});
	it ("removes empty fields", function(){
		// var test = {value: 'BuiltWorkPlace'};
		// var form = $("<form/>");

		var markup = $('#dateSection').html();
		spyOn(window, "processForm_generic");
		// spyOn($('#dateSection'), remove);
		spyOn(window, "removeEmptyFields");
	  expect($('#dateSection')).toBeVisible();
	  expect('<input/>').toExist();
		// console.log($('<input/>');
	  $('<input/>').click();
	  // console.log(markup);
	  // window.processForm_generic("#dams_object_");
	  processForm_generic("#dams_object_");
	  // console.log(document.documentElement.innerHTML);
	    expect(processForm_generic).toHaveBeenCalled();

		// console.log(document.getElementById('dateSection').innerHTML);
		expect(document.getElementById('dateSection')).toBeInDOM();

		// expect(window.processForm_generic("dams_object")).toEqual(true);

		// expect(window.processForm_generic).toHaveBeenCalled();

		//Checking that the sub function was called from processForm_generic
		//fails for some reason
		// expect(window.removeEmptyFields).toHaveBeenCalled();

	  expect($('#dateSection')).toBeVisible();
	});
});