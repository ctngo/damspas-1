describe ("Add", function() {
	var test;
	var onSuccess, onFailure;
	beforeEach(function(){
				//var fixture = loadFixtures('test.html')
// jasmine.Ajax.useMock();
		onSuccess = jasmine.createSpy('onSuccess');
    onFailure = jasmine.createSpy('onFailure');
    // window.getDynamicFields(test, 'dams_object', '#newSimpleSubjects', "0", 'simpleSubject', 'undefined', null, null, { onSuccess: onSuccess,
      // onFailure: onFailure
    // });
    		// request = mostRecentAjaxRequest();

		test = jasmine.createSpy('test', window.getDynamicFields);
	});
	it ("adds field to object create form", function(){
		var test = {value: 'BuiltWorkPlace'};

    spyOn($, "get");
		getDynamicFields(test, 'dams_object', '#newSimpleSubjects', "0", 'simpleSubject', 'undefined');
		expect($.get).toHaveBeenCalled();

		expect($.get).toHaveBeenCalledWith('http://localhost:3000/get_data/get_subject/get_subject?selectedValue=undefined&fieldId=0&fieldName=builtWorkPlace&formType=dams_object&q=BuiltWorkPlace', jasmine.any(Function))

	});

});