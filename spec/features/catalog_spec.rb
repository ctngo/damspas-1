require 'spec_helper'

feature 'Visitor wants to search' do
  scenario 'is on search results page' do
    visit catalog_index_path( {:q => 'sample'} )
    expect(page).to have_selector('h4', :text => 'Limit your search')
    expect(page).to have_selector('h3', :text => 'Sample Simple Object')
    expect(page).to have_selector("img.dams-search-thumbnail:first")
    expect(page).to have_selector("a.dams-search-thumbnail-link:first")
  end
  scenario 'is on a browse results page' do
    # should show links to remove facets, even when there is no query
    visit catalog_index_path( {'f[unit_sim][]' => 'Library Digital Collections'} )
    expect(page).to have_selector("div.dams-search-constraints")
    expect(page).to have_selector("span.dams-filter")
  end
  scenario 'results sorted by relevance improvement: title name subject' do
    sign_in_developer
    visit catalog_index_path( {'q' => 'Dissertations', 'per_page' => 100, 'sort' => 'score desc, system_create_dtsi desc, title_ssi asc'} )
    idx1 = page.body.index('Historical Dissertations')  # title matched, no date
    idx2 = page.body.index('Chicano and black radical activism of the 1960s: a comparison between the Brown Berets and the Black Panther Party in California')      # subject matched, 2010
    idx3 = page.body.index('Sample Complex Object Record #1') # subject matched, no date
    idx4 = page.body.index('The real thing')   # collection matched, no date
    idx3.should > idx1
    idx2.should > idx1
    idx4.should > idx3
    idx4.should > idx2

    click_on "The real thing"
    expect(page).to have_selector('div.search-results-pager')
  end
  scenario 'results sorted by object creation date' do
    sign_in_developer
    visit catalog_index_path( {'f[unit_sim][]' => 'Library Digital Collections', 'per_page' => 100, 'sort' => 'object_create_dtsi asc, title_ssi asc'} )
    idx1 = page.body.index('Sample Audio Object: I need another')  # no date
    idx2 = page.body.index('Sample Complex Object Record #1')      # 1980
    idx3 = page.body.index('Chicano and black radical activism')   # 2010
    idx4 = page.body.index('Sample Simple Object')                 # 2012-04-08
    idx4.should >( idx3 )
    idx3.should >( idx2 )
    idx2.should >( idx1 )

    click_on "Chicano and black radical activism"
    expect(page).to have_selector('div.search-results-pager')
  end
  scenario 'system queries should show search results' do
    visit catalog_index_path( {:fq => ['{!join from=collections_tesim to=id}unit_code_tesim:dlp']} )
    expect(page).to have_selector('ol#dams-search-results li div h3')
  end
end
