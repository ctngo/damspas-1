require "base64"
require "openssl"

module DamsObjectsHelper

  #---
    # Openurl, embedded metadata support,
    # Get metadata from solr document, and parsing each field and produce openURL key-encoded value query strings.
    # hweng@ucsd.edu
  #---
  def field_mapping(fieldName)
       data_arr=[]
       index = getComponentIndex

     fieldData = @document["#{index}#{fieldName}"]
     if fieldData != nil
      fieldData.each do |value|
        data_arr.push(value)
        end
     end
     data_arr
    end

   def export_as_openurl
        query_string = []
        query_string << "url_ver=Z39.88-2004&ctx_ver=Z39.88-2004&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Adc&rfr_id=info%3Asid%2Fblacklight.rubyforge.org%3Agenerator"
        field_map = {
          'title' => getTitle,
          'rights'=> getCopyright,
          'subject'=>getSubject,
          'creator'=>getCreator,
          'date'=>getDate,
          'format'=>getFormat,
          'language'=> getLanguage,
          'identifier'=>getIdentifier
          
        }
        field_map.each do |kev, values|
          next if values.empty? or values.first.nil?
          values.each do |value|
            query_string << "rft.#{kev}=#{CGI::escape(value)}"
          end
        end
        query_string.join('&') unless query_string.blank?
    end

    def getComponentIndex
        index = (defined?(componentIndex)) ? "component_#{componentIndex}_" : ''
     end
    
    def getTitle
       data_arr=[]
       index = getComponentIndex
       fieldData = @document["#{index}title_json_tesim"]
       
       if fieldData != nil
       	 fieldData.each do |datum|
       	 	title = JSON.parse(datum)
       	 	if title['value'] != ''
       	 		data_arr.push(title['value'])
       	 	end
       	  end
       	end 
       	data_arr
    end

    def getSubject
       fieldValue=field_mapping('subject_tesim')
    end

    def getCreator
      fieldValue=field_mapping('name_tesim')
    end

    def getDate
       data_arr=[]
       index = getComponentIndex
       fieldData = @document["#{index}date_json_tesim"]
       
       if fieldData != nil
       	 fieldData.each do |datum|
       	 	date = JSON.parse(datum)
       	 	if date['value'] != ''
       	 		data_arr.push(date['value'])
       	 	end
       	  end
       	end 
       	data_arr
    end

    def getFormat
      fieldValue=field_mapping('resource_type_tesim')
    end

    def getLanguage
        fieldValue=field_mapping('language_tesim')
    end

    def getIdentifier
       data_arr=[]
       index = getComponentIndex
     fieldData = @document["#{index}note_json_tesim"]

     if fieldData != nil
       fieldData.each do |datum|
          note = JSON.parse(datum)
          if note['displayLabel'] == 'ARK'
            data_arr.push(note['value'])
          end
       end
      end
     data_arr
    end

    # Parse metadata from JSON format for copyright.
    def getCopyright
       data_arr=[]
       index = getComponentIndex
     fieldData = @document["#{index}copyright_tesim"]
     if fieldData != nil
      fieldJSON = JSON.parse(fieldData.first)
        temp =fieldJSON['purposeNote']
        temp ='purposeNote: '+temp + ' '+'note: '+fieldJSON['note']
        data_arr.push(temp)
     end
     data_arr
    end

  #--
  # End of openURL implementation
  #    

  #---
  # select_file: Select files to display
  #---
  def select_file( params )
    document  = params[:document]
    component = params[:component]
    max_size  = params[:quality]
    type      = params[:type]
  
    prefix = (component != nil) ? "component_#{component}_" : ""
    files = document["#{prefix}files_tesim"]

    # identify acceptable files
    service_use = nil
    service_dim = 0
    service_json = nil
    display_dim  = 0
    display_json = nil
    if files != nil
      files.each{ |f|
        fjson = JSON.parse(f)
        fid = fjson["id"]
        use = fjson["use"]
        if use != nil
          use = use.first
        end
        qual = fjson["quality"]
        if qual != nil
          qualArr = qual.split("x")
          file_dim = qualArr.max { |a,b| a.to_i <=> b.to_i }.to_i
        end
        if type == nil || use.start_with?(type)
          if use != nil && use.end_with?("-service")
            if (service_json == nil || service_use.start_with?("image-") )
              service_json = fjson
              service_use = use
              service_dim = file_dim.to_i
            end
          elsif max_size == nil || file_dim == nil || file_dim.to_i < max_size
            if (display_json == nil || file_dim.to_i > display_dim) && use != nil && (not use.end_with?("-source") )
              display_json = fjson
              display_dim  = file_dim.to_i
            end
          end
        end
      }
    end
  
    # build file metadata hash
    info = Hash.new
    if ( service_json != nil )
      info[:service] = service_json
    end
    if ( display_json != nil )
      info[:display] = display_json
    end
    info
  end

  #---
  # render_file_use
  #---
  def render_file_use( params )
    component = params[:component]
		quality = params[:quality]

    if component=="0"
      files = select_file( :document=>@document, :quality=>quality )
    else
      files = select_file( :document=>@document, :component=>component, :quality=>quality )
    end
   
    file_info = files[:service]
    if file_info != nil
      use = file_info['use'].first
    end
  end

  #---
  # render_service_file
  #---
  def render_service_file( params )
    component = params[:component]
		quality = params[:quality]

    if component=="0"
      files = select_file( :document=>@document, :quality=>quality )
    else
      files = select_file( :document=>@document, :component=>component, :quality=>quality )
    end

    service_file = files[:service]
    if service_file != nil
      services=service_file["id"]
    end
  end

  #---
  # render_display_file
  #---
  def render_display_file( params )
    component = params[:component]
		quality = params[:quality]

    if component=="0"
      files = select_file( :document=>@document,:quality=>quality )
    else
      files = select_file( :document=>@document, :component=>component, :quality=>quality )
    end

    if files.has_key?(:display)
      display_file = files[:display]
      display=display_file["id"]
    else
      service_file = files[:service]
      if service_file != nil
        services=service_file["id"]
      
        #---
        # todo: replace no_display with appreciate icons"
        #--
        if services.include?('mp3')
          display = "no_display" 
        elsif services.include?('tar.gz')||services.include?('tar')||services.include?('zip')||services.include?('xml')
          display = "no_display"
        end
      end
    end
    display
  end

	#---
	# POST SOLR UPDATE REWRITES
	#---

	#---
	# Get the display file id value from the component's 'files_tesim' value. Replaces 'render_display_file'.
	#
	# @param quality (Optional) The quality of the display file. Possible values: 'icon', 'thumbnail', 'preview' (Default), 'large' and 'huge'
	# @param componentIndex (Optional) The component's index.
	# @return If found, returns a string that is the component's display file id value, otherwise returns 'no_display'
	# @author David T.
	#---
	def grabDisplayFile(parameters={})

		p = {:componentIndex=>nil,:quality=>'preview'}.merge(parameters)
		componentIndex = p[:componentIndex]
		validQualities = Set.new ['icon', 'thumbnail', 'preview', 'large', 'huge']
		quality = (validQualities.include? p[:quality].downcase) ? p[:quality].downcase : 'preview'

		prefix = (componentIndex != nil) ? "component_#{componentIndex}_" : ''
		fieldData = @document["#{prefix}files_tesim"]
		result = 'no_display'

		if fieldData != nil
			fieldData.each do |datum|
				files = JSON.parse(datum)
				if files["use"].end_with?("-#{quality}")
					result = files["id"]
					break
				end
			end
		end

		return result
	end

	#---
	# Get the service file id value from the component's 'files_tesim' value. Replaces 'render_service_file'.
	#
	# @param componentIndex (Optional) The component's index.
	# @return A string that is the component's file id value
	# @author David T.
	#---
	def grabServiceFile(parameters={})

		p = {:componentIndex=>nil}.merge(parameters)
		componentIndex = p[:componentIndex]

		prefix = (componentIndex != nil) ? "component_#{componentIndex}_" : ''
		fieldData = @document["#{prefix}files_tesim"]
		result = nil

		if fieldData != nil
			fieldData.each do |datum|
				files = JSON.parse(datum)
				if files["use"].end_with?("-service")
					result = files["id"]
					break
				end
			end
		end

		return result
	end

	#---
	# Get the file use value from the component's 'files_tesim' value. Replaces 'render_file_use'.
	#
	# @param componentIndex (Optional) The component's index.
	# @return A string that is the component's file use (type/role) value. E.g., "image-service", "audio-service", etc.
	# @author David T.
	#---
	def grabFileUse(parameters={})

		p = {:componentIndex=>nil}.merge(parameters)
		componentIndex = p[:componentIndex]

		prefix = (componentIndex != nil) ? "component_#{componentIndex}_" : ''
		fieldData = @document["#{prefix}files_tesim"]
		result = nil

		if fieldData != nil
			fieldData.each do |datum|
				files = JSON.parse(datum)
				if files["use"].end_with?("-service")
					result = files["use"]
					break
				end
			end
		end

		return result
	end

	#------------------------
	# COMPONENT TREE METHODS
	#------------------------

	#---
	# Get the object's title
	#
	# @param componentIndex (Optional) The component's index.
	# @return A string that is the title value for our object.
	# @author David T.
	#---
	def grabTitle(parameters={})

		p = {:componentIndex=>nil}.merge(parameters)
		componentIndex = p[:componentIndex]

		prefix = (componentIndex != nil) ? "component_#{componentIndex}_" : ''
		fieldData = @document["#{prefix}title_json_tesim"]
		result = nil

		if fieldData != nil
			title = JSON.parse(fieldData.first)
			result = title['value']
		end

	end

	#---
	# Get the file type value from the component's file use value
	#
	# @param fileUse The component's file use (type/role) value. E.g., "image-service", "audio-service", etc.
	# @return A string that is the file type value for our component.
	# @author David T.
	#---
	def grabFileType(fileUse)
		fileType = (fileUse) ? fileUse.split("-").first : 'no-files'
	end

	#---
	# Determines which Bootstrap icon glyph to use based on a component's file type.
	#
	# @param fileUse The component's file use (type/role) value. E.g., "image-service", "audio-service", etc.
	# @return A string that is the CSS class name of the icon we want to display.
	# @author David T.
	#---
	def grabIcon(fileUse)
		icon = grabFileType(fileUse)
		case icon
			when 'image'
				icon = 'icon-picture'
			when 'audio'
				icon = 'icon-music'
			when 'video'
				icon = 'icon-film'
			when 'no-files'
				icon = 'icon-stop'
			else
				icon ='icon-file'
		end
		return icon
	end

	#---
	# Renders a node of the COV component tree.
	#
	# @param index The object's component index.
	# @return nil
	# @author David T.
	#---
	def displayNode(index)

		fileUse = grabFileUse(:componentIndex=>index)
		btnAttrForFiles = "onClick='dp.COV.showComponent(#{index});'"
		btnID = "node-btn-#{index}"
		btnCSS = (fileUse) ? "node-file #{@firstButton}" : ''
		btnCSS += (@isParent[index]) ? ' node-parent' : ''
		iconCSS = (@isParent[index]) ? 'icon-chevron-right node-toggle' : grabIcon(fileUse)
		btnTitle = grabTitle(:componentIndex=>index)

		concat "<li>".html_safe
		concat "<i class='#{iconCSS} node-icon'></i> <button type='button' id='#{btnID}' class='btn btn-small btn-link #{btnCSS}' #{btnAttrForFiles}>#{btnTitle}</button>".html_safe

		# Display children if parent
		if (@isParent[index])

			concat "<ul class='unstyled node-container'>".html_safe
			@document["component_#{index}_children_isim"].each do |sub|
				displayNode sub
				@seen.push(sub)
			end
			concat "</ul>".html_safe

		end

		concat "</li>".html_safe

		@firstButton = nil

	end

	#---
	# Renders the COV component tree.
	#
	# @param component_count An integer value representing the amount of components an object has ("component_count_isi").
	# @return nil
	# @author David T.
	#---
	def displayComponentTree(component_count)
		if component_count != nil && component_count > 0
			concat '<ul class="unstyled">'.html_safe
			for i in 1..component_count
				if @seen.count(i) == 0
					displayNode i
				end
			end
			concat '</ul>'.html_safe
		end
		return nil
	end

	#---
	# Initializes the arrays used to build the COV component tree.
	#
	# @param component_count An integer value representing the amount of components an object has ("component_count_isi").
	# @return nil
	# @author David T.
	#---
	def initComponentTree(component_count)
		if component_count != nil
			@isParent = []
			@isChild = []
			@seen = []

			for i in 1..component_count
				@isParent[i] = false
				@isChild[i] = false
			end

			for i in 1..component_count
				if @document["component_#{i}_children_isim"] != nil
					@isParent[i] = true
					@document["component_#{i}_children_isim"].each do |j|
						@isChild[j] = true
					end
				end
			end
		end
		return nil
	end

	#-------------------------
	# /COMPONENT TREE METHODS
	#-------------------------


  ## video stream name encryption
  def encrypt_stream_name( pid, fid, ip )

    # random nonce
    nonce=rand(36**16).to_s(36)
    while nonce.length < 16 do
      nonce += "x"
    end

    # load key from file
    key= File.read ViewOptions::VIDEO_PARENT_DIRECTORY + '/streaming.key'

    # encrypt
    str="#{pid} #{fid} #{ip}"
    cipher = OpenSSL::Cipher::AES.new(128,:CBC)
    cipher.encrypt
    cipher.key = key
    cipher.iv = nonce
    enc = cipher.update(str) + cipher.final

    # base64-encode
    b64 = Base64.encode64 enc
    b64 = b64.gsub("+","-").gsub("/","_").gsub("\n","")
    "#{nonce},#{b64}"
  end
end
